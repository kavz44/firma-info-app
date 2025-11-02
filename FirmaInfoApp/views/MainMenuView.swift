//
//  MainMenuView.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 05/10/2025.
//

import SwiftUI


struct MainMenuView: View {
    @StateObject private var viewModel = FirmaViewModel()
    @StateObject private var regnskapViewModel = RegnskapViewModel()
    
    
    var body: some View {
        
      
        ZStack{
            Image("backround")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .sheet(isPresented: .constant(true)) {
            SearchSheetView(query: $viewModel.query, forslag: viewModel.forslag, regnskapViewModel: regnskapViewModel)
                .presentationDetents([.height(160), .medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled(true)
                //.presentationBackground(.regularMaterial)
                
        }
                                
    }
}

// TODO: Flytt til egen fil når ferdig testa
struct SearchSheetView: View {
    @Binding var query: String
    let forslag: [Firma]
    @ObservedObject var regnskapViewModel: RegnskapViewModel
    
    var filteredForslag: [Firma] {
        if query.isEmpty { return forslag }
        return forslag.filter { $0.navn.lowercased().contains(query.lowercased()) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                Text("Hvilket selskap skal søkes opp?")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title3)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .padding(.vertical)
                

                TextField("Søk her ... (UNDER CONSTRUCTION)", text: $query)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(filteredForslag) { firma in
                            
                            Button(action: {
                                print("her ble \(firma.navn) trykket på!")
                                print("orgnr: \(firma.orgnummer)")
                                
                                // Henter regnskapsdata
                                regnskapViewModel.hentRegnskapsdata(orgnr: firma.orgnummer, organisasjonsform: firma.organisasjonsform.kode )
                                
                            }) {
                                Label(firma.navn, systemImage: "building.2")
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundStyle(.white)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                
            }
            
        }
    }
}


#Preview {
    MainMenuView()
}
