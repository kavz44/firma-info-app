//
//  RegnskapRespons.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 02/11/2025.
//

import Foundation

struct RegnskapResponse: Codable {
    let id: Int
    let journalnr: String?
    let regnskapstype: String?
    let virksomhet: Virksomhet
    let regnskapsperiode: Regnskapsperiode
    let valuta: String?
    let avviklingsregnskap: Bool
    let oppstillingsplan: String?
    let revisjon: Revisjon
    let regnkapsprinsipper: Regnskapsprinsipper
    let egenkapitalGjeld: EgenkapitalGjeld
    let eiendeler: Eiendeler
    let resultatregnskapResultat: ResultatregnskapResultat
}

struct Virksomhet: Codable {
    let organisasjonsnummer: String?
    let organisasjonsform: String?
    let morselskap: Bool
}

struct Regnskapsperiode: Codable {
    let fraDato: String
    let tilDato: String
}

struct Revisjon: Codable {
    let ikkeRevidertAarsregnskap: Bool
    let fravalgRevisjon: Bool
}

struct Regnskapsprinsipper: Codable {
    let smaaForetak: Bool?
    let regnskapsregler: String?
}

struct EgenkapitalGjeld: Codable {
    let sumEgenkapitalGjeld: Int?
    let egenkapital: Egenkapital
    let gjeldOversikt: GjeldOversikt
}

struct Egenkapital: Codable {
    let sumEgenkapital: Int?
    let opptjentEgenkapital: OpptjentEgenkapital
    let innskuttEgenkapital: InnskuttEgenkapital
}

struct OpptjentEgenkapital: Codable {
    let sumOpptjentEgenkapital: Int?
}

struct InnskuttEgenkapital: Codable {
    let sumInnskuttEgenkaptial: Int?
}

struct GjeldOversikt: Codable {
    let sumGjeld: Int?
    let kortsiktigGjeld: KortsiktigGjeld
    let langsiktigGjeld: LangsiktigGjeld
}

struct KortsiktigGjeld: Codable {
    let sumKortsiktigGjeld: Int?
}

struct LangsiktigGjeld: Codable {
    let sumLangsiktigGjeld: Int?
}

struct Eiendeler: Codable {
    let sumEiendeler: Int?
    let omloepsmidler: Omloepsmidler
    let anleggsmidler: Anleggsmidler
}

struct Omloepsmidler: Codable {
    let sumOmloepsmidler: Int?
}

struct Anleggsmidler: Codable {
    let sumAnleggsmidler: Int?
}

struct ResultatregnskapResultat: Codable {
    let ordinaertResultatFoerSkattekostnad: Int?
    let aarsresultat: Int?
    let finansresultat: Finansresultat
    let driftsresultat: Driftsresultat
}

struct Finansresultat: Codable {
    let nettoFinans: Int?
    let finansinntekt: Finansinntekt
    let finanskostnad: Finanskostnad
}

struct Finansinntekt: Codable {
    let sumFinansinntekter: Int?
}

struct Finanskostnad: Codable {
    let sumFinanskostnad: Int?
}

struct Driftsresultat: Codable {
    let driftsresultat: Int?
    let driftsinntekter: Driftsinntekter
    let driftskostnad: Driftskostnad
}

struct Driftsinntekter: Codable {
    let sumDriftsinntekter: Int?
}

struct Driftskostnad: Codable {
    let sumDriftskostnad: Int?
}
