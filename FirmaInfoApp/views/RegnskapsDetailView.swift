//
//  RegnskapsDetailView.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 02/11/2025.
//

import SwiftUI

struct RegnskapDetailView: View {
    let firmaNavn: String
    let regnskap: [RegnskapResponse]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("(UNDER CONSTRUCTION) Noen tall for \(firmaNavn)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom)

            ScrollView {
                ForEach(regnskap.indices, id: \.self) { index in
                    let r = regnskap[index]
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Regnskapsårr: \(r.regnskapsperiode.fraDato.prefix(4))")
                        Text("Valuta: \(r.valuta)")
                        Text("Sum eiendeler: \(r.eiendeler.sumEiendeler)")
                        Text("Sum egenkapital: \(r.egenkapitalGjeld.egenkapital.sumEgenkapital)")
                        Text("Sum gjeld: \(r.egenkapitalGjeld.gjeldOversikt.sumGjeld)")
                        Text("Årsresultat: \(r.resultatregnskapResultat.aarsresultat)")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle(firmaNavn)
        .navigationBarTitleDisplayMode(.inline)
    }
}
