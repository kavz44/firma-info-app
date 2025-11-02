//
//  RegnskapRespons.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 02/11/2025.
//

import Foundation

struct RegnskapResponse: Codable {
    let id: Int
    let journalnr: String
    let regnskapstype: String
    let virksomhet: Virksomhet
    let regnskapsperiode: Regnskapsperiode
    let valuta: String
    let avviklingsregnskap: Bool
    let oppstillingsplan: String
    let revisjon: Revisjon
    let regnkapsprinsipper: Regnskapsprinsipper
    let egenkapitalGjeld: EgenkapitalGjeld
    let eiendeler: Eiendeler
    let resultatregnskapResultat: ResultatregnskapResultat
}

struct Virksomhet: Codable {
    let organisasjonsnummer: String
    let organisasjonsform: String
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
    let smaaForetak: Bool
    let regnskapsregler: String
}

struct EgenkapitalGjeld: Codable {
    let sumEgenkapitalGjeld: Double
    let egenkapital: Egenkapital
    let gjeldOversikt: GjeldOversikt
}

struct Egenkapital: Codable {
    let sumEgenkapital: Double
    let opptjentEgenkapital: OpptjentEgenkapital
    let innskuttEgenkapital: InnskuttEgenkapital
}

struct OpptjentEgenkapital: Codable {
    let sumOpptjentEgenkapital: Double
}

struct InnskuttEgenkapital: Codable {
    let sumInnskuttEgenkaptial: Double
}

struct GjeldOversikt: Codable {
    let sumGjeld: Double
    let kortsiktigGjeld: KortsiktigGjeld
    let langsiktigGjeld: LangsiktigGjeld
}

struct KortsiktigGjeld: Codable {
    let sumKortsiktigGjeld: Double
}

struct LangsiktigGjeld: Codable {
    let sumLangsiktigGjeld: Double
}

struct Eiendeler: Codable {
    let sumEiendeler: Double
    let omloepsmidler: Omloepsmidler
    let anleggsmidler: Anleggsmidler
}

struct Omloepsmidler: Codable {
    let sumOmloepsmidler: Double
}

struct Anleggsmidler: Codable {
    let sumAnleggsmidler: Double
}

struct ResultatregnskapResultat: Codable {
    let ordinaertResultatFoerSkattekostnad: Double
    let aarsresultat: Double
    let finansresultat: Finansresultat
    let driftsresultat: Driftsresultat
}

struct Finansresultat: Codable {
    let nettoFinans: Double
    let finansinntekt: Finansinntekt
    let finanskostnad: Finanskostnad
}

struct Finansinntekt: Codable {
    let sumFinansinntekter: Double
}

struct Finanskostnad: Codable {
    let sumFinanskostnad: Double
}

struct Driftsresultat: Codable {
    let driftsresultat: Double
    let driftsinntekter: Driftsinntekter
    let driftskostnad: Driftskostnad
}

struct Driftsinntekter: Codable {
    let sumDriftsinntekter: Double
}

struct Driftskostnad: Codable {
    let sumDriftskostnad: Double
}
