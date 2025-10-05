//
//  MainMenuView.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 05/10/2025.
//

import SwiftUI


struct MainMenuView: View {
    @StateObject private var viewModel = FirmaViewModel()
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Image("backround")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if (!viewModel.forslag.isEmpty) {
                    
                    ScrollView{
                        VStack(alignment: .leading){
                            ForEach(viewModel.forslag) {firma in
                                Button(action: {
                                    viewModel.velgForslag(firma: firma)
                                }){
                                    VStack(alignment: .leading){
                                        if #available(iOS 26.0, *) {
                                            Text("Firmanavn: \(firma.navn)")
                                                .glassEffect()
                                        } else {
                                            // Fallback on earlier versions
                                            
                                            // Text("Orgnr: \(firma.orgnummer)")
                                            // if let adresse = firma.forretningsadresse?.poststed {
                                            // Text("Adresse: \(adresse)")
                                            // }
                                        }
                                    }
                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
            }
        } // navigationStack end
        .searchable(text: $viewModel.query)
        .searchSuggestions{
            ForEach(viewModel.forslag) { firma in
                Text("\(firma.navn)")
            }
            
        }
    }
}


#Preview {
    MainMenuView()
}
