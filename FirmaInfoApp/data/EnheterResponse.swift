//
//  EnheterResponse.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 01/10/2025.
//


struct EnheterResponse: Codable, Sendable {
    let _embedded: Enheter
}

struct Enheter: Codable, Sendable {
    let enheter: [Firma]
}
