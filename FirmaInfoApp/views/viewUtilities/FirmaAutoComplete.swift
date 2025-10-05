//
//  FirmaAutoCompleteView.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 01/10/2025.
//

import SwiftUI

struct FirmaAutocomplete: View {
    @StateObject private var viewModel = FirmaViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                
                // Dropdown med forslag
                if !viewModel.forslag.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.forslag) { firma in
                                Button(action: {
                                    viewModel.velgForslag(firma: firma)
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(firma.navn).bold()
                                        Text("Org.nr: \(firma.orgnummer)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        if let adresse = firma.forretningsadresse?.poststed {
                                            Text(adresse).font(.subheadline)
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                Divider()
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 3)
                    }
                    .frame(maxHeight: 300)
                }
                
                Spacer()
            }
            .padding()
        } // NavigationStach end
        .searchable(text: $viewModel.query)
    }
}

#Preview {
    FirmaAutocomplete()
}
