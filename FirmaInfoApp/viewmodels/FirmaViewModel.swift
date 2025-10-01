//
//  FirmaViewModel.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 01/10/2025.
//

import Foundation
import Combine

class FirmaViewModel: ObservableObject {
    @Published var query = ""
    @Published var forslag: [Firma] = []
    
    // cache data:
    private var cache: [String: [Firma]] = [:]
    
    // Filtre på API-kallet:
    let maks_antall_sok = "size=10"
    let sorter_antall_ansatte = "sort=antallAnsatte,DESC"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observer query og kall API med debounce
        $query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.hentForslag(query: value)
            }
            .store(in: &cancellables)
    }
    
    func hentForslag(query: String) {
        guard !query.isEmpty else {
            forslag = []
            return
        }
        
        if let cached = cache[query.lowercased()] {
                self.forslag = cached
                return
            }
        
        // 2 linjene under vil fjerne valgte spesialtegn og endre til percentage encoding, så det ikke fører til feil ved kall til API
        let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
        print(encodedQuery)
        let urlString = "https://data.brreg.no/enhetsregisteret/api/enheter?navn=\(encodedQuery)&navnMetodeForSoek=FORTLOEPENDE&\(maks_antall_sok)&\(sorter_antall_ansatte)"
        print("**URL: \(urlString) **")
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(EnheterResponse.self, from: data)
                let results = Array(response._embedded.enheter.prefix(10))
                self.cache[query.lowercased()] = results
                var filtrerteResultat = results.sorted {
                    $0.navn.lowercased().hasPrefix(query.lowercased()) &&
                   !$1.navn.lowercased().hasPrefix(query.lowercased())
                }
                filtrerteResultat = filtrerteResultat.filter {
                    $0.navn.lowercased().hasPrefix(query.lowercased())
                }
                self.forslag = filtrerteResultat
            } catch {
                print("*****Feil ved dekoding: \(error)*****")
            }
        }
    }
    
    func velgForslag(firma: Firma) {
        self.query = firma.navn
        self.forslag = []
    }
}
