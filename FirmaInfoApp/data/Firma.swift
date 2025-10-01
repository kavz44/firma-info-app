//
//  Firma.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 01/10/2025.
//


import Foundation

struct Firma: Identifiable, Codable, Sendable {
    var id: String {orgnummer} // Bruker orgnummer som id fordi alle er unike
    let navn: String
    let orgnummer: String
    let organisasjonsform: OrgForm?
    let forretningsadresse: Adresse?
    let stiftelsesdato: String?
    let sisteInnsendteAarsregnskap: String? // årstall
    let konkurs: Bool
    let underAvvikling: Bool
    let Tvangsopplosning_avlos: Bool
    let erIKonsern: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case navn
        case orgnummer = "organisasjonsnummer"
        case organisasjonsform
        case forretningsadresse
        case stiftelsesdato
        case sisteInnsendteAarsregnskap
        case konkurs
        case underAvvikling
        case Tvangsopplosning_avlos = "underTvangsavviklingEllerTvangsopplosning"
        case erIKonsern
    }
}

struct Adresse: Codable, Sendable {
    let postnummer: String?
    let poststed: String?
}

struct OrgForm: Codable, Sendable {
    let kode: String
}
