//
//  RegnskapViewModel.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 02/11/2025.
//

import Foundation
import Combine

class RegnskapViewModel: ObservableObject {
    // ide: lagre data i dict med orgnr som nokkel, en slags mellomlagring av tidligere søk.
    @Published var regnskapsData: [String: [RegnskapResponse]] = [:]
    
    // alle koder:  AAFY, ADOS, ANNA, ANS, AS, ASA, BA, BBL, BEDR, BO, BRL, DA, ENK, EOFG, ESEK, FKF, FLI, FYLK, GFS, IKJP, IKS, KBO, KF, KIRK, KOMM, KS, KTRF, NUF, OPMV, ORGL, PERS, PK, PRE, SA, SAM, SE, SF, SPA, STAT, STI, SÆR, TVAM, UTLA, VPFO

    // Organisasjonsformer med regnskap
    let organisasjonsformerMedOffentligRegnskap: [String] = ["ANS", "AS", "ASA", "BA", "DA", "NUF", "SA", "SF", "STI"]
    
    // org koder uten
    let organisasjonsformerUtenOffentligRegnskap: [String] = ["AAFY", "ADOS", "ANNA", "BBL", "BEDR", "BO", "BRL", "ENK", "EOFG", "ESEK", "FKF", "FLI", "FYLK", "GFS", "IKJP", "IKS", "KBO", "KF", "KIRK", "KOMM", "KS", "KTRF", "OPMV", "ORGL", "PERS", "PK", "PRE", "SAM", "SE", "SPA", "STAT", "SÆR", "TVAM", "UTLA", "VPFO"]

    
    func hentRegnskapsdata(orgnr: String, aar: Int = 2024, organisasjonsform: String) {
        // sjekk om allerede hentet fra API
        if let cached = regnskapsData[orgnr] {
            print("Bruker cachet data for \(orgnr): \(cached)")
            return
        }
        
        if !organisasjonsformerMedOffentligRegnskap.contains(organisasjonsform){
            //debug
            print("orgnr \(orgnr) med orgform \(organisasjonsform) har IKKE regnskap")
            regnskapsData[orgnr] = nil
            return
        }

        // ellers hent fra API
        
        guard let url = URL(string: "https://data.brreg.no/regnskapsregisteret/regnskap/\(orgnr)?år=\(aar)&regnskapstype=SELSKAP")
            else {
                print("Ugyldig URL")
                return
            }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        //debug
        print("henter fra url: \(url)")
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                print("data hentet fra API")
                
                
                let response = try JSONDecoder().decode([RegnskapResponse].self, from: data)
                
                // lagre i cachen
                await MainActor.run {
                    self.regnskapsData[orgnr] = response
                }

            } catch {
                print("Feil under henting: \(error)")
            }
        }
    }
    
}
