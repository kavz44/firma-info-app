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
            Text("(UNDER CONSTRUCTION) \nNoen tall for \(firmaNavn)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom)

            ScrollView {
                ForEach(regnskap.indices, id: \.self) { index in
                    let r = regnskap[index]
                    VStack(alignment: .leading, spacing: 8) {
                        Text(verbatim: "Regnskapsår: \(r.regnskapsperiode.fraDato.prefix(4))")
                        Text(verbatim: "Valuta: \(r.valuta ?? "ukjent")")
                        Text(verbatim: "Sum eiendeler: \(r.eiendeler.sumEiendeler ?? 0)")
                        Text(verbatim: "Sum egenkapital: \(r.egenkapitalGjeld.egenkapital.sumEgenkapital ?? 0)")
                        Text(verbatim: "Sum gjeld: \(r.egenkapitalGjeld.gjeldOversikt.sumGjeld ?? 0)")
                        Text(verbatim: "Årsresultat: \(r.resultatregnskapResultat.aarsresultat ?? 0)")
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
