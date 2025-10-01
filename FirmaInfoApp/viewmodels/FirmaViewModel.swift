//
//  FirmaViewModel.swift
//  FirmaInfoApp
//
//  Created by Kavin Gregary Anand on 01/10/2025.
//

import Foundation
import Combine

class FirmaViewModel: ObservableObject {
    @Published var query = ""
    @Published var forslag: [Firma] = []
    
    // Filtre på API-kallet:
    let maks_antall_sok = "size=10"
    let sorter_antall_ansatte = "sort=antallAnsatte,DESC"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observer query og kall API med debounce
        $query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.hentForslag(query: value)
            }
            .store(in: &cancellables)
    }
    
    func hentForslag(query: String) {
        guard !query.isEmpty else {
            forslag = []
            return
        }
        
        let urlString = "https://data.brreg.no/enhetsregisteret/api/enheter?navn=\(query)&\(maks_antall_sok)&\(sorter_antall_ansatte)"
        print("**URL: \(urlString) **")
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(EnheterResponse.self, from: data)
                self.forslag = Array(response._embedded.enheter.prefix(10))
            } catch {
                print("*****Feil ved dekoding: \(error)*****")
            }
        }
    }
    
    func velgForslag(firma: Firma) {
        self.query = firma.navn
        self.forslag = []
    }
}
