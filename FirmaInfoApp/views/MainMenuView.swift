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
        
        ZStack{
            Image("backround")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            FirmaAutocomplete()
        }
    }
    
    
    
    
}


#Preview {
    MainMenuView()
}
