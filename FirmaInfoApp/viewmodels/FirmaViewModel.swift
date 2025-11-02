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
    
    // cache data:
    private var cache: [String: [Firma]] = [:]
    
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
        
        if let cached = cache[query.lowercased()] {
                self.forslag = cached
                return
            }
        
        // 2 linjene under vil fjerne valgte spesialtegn og endre til percentage encoding, så det ikke fører til feil ved kall til API
        let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
        print(encodedQuery)
        let urlString = "https://data.brreg.no/enhetsregisteret/api/enheter?navn=\(encodedQuery)&navnMetodeForSoek=FORTLOEPENDE&\(maks_antall_sok)&\(sorter_antall_ansatte)"
        print("**URL: \(urlString) **")
        guard let url = URL(string: urlString) else {return}
        
        Task {
            await fetchWithRetry(url: url, query: query)
        }

    }
    
    private func fetchWithRetry(url: URL, query: String, attempt: Int = 1, maxAttempts: Int = 3) async {
        do {
            let (data, statusResponse) = try await URLSession.shared.data(from: url)
            
            // sjekker HTTP status code
            if let httpResponse = statusResponse as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
            }
            
            print("data hentet fra API")
            // DEBUGGING
//                    if let rawResponse = String(data: data, encoding: .utf8) {
//                        print("RAW RESPONSE:")
//                        print(rawResponse)
//                    } else {
//                        print("Kunne ikke konvertere data til tekst")
//                    }
            
            // DEBUGGING
            let response = try JSONDecoder().decode(EnheterResponse.self, from: data)
            let results = Array(response._embedded.enheter.prefix(10))
            
            await MainActor.run {
                self.cache[query.lowercased()] = results
                // TODO: Kan optimaliseres! kun enten sorted eller filter trengs her.
                var filtrerteResultat = results.sorted {
                    $0.navn.lowercased().hasPrefix(query.lowercased()) &&
                    !$1.navn.lowercased().hasPrefix(query.lowercased())
                }
                filtrerteResultat = filtrerteResultat.filter {
                    $0.navn.lowercased().hasPrefix(query.lowercased())
                }
                self.forslag = filtrerteResultat
            }
            print("done, no catch")
        } catch {
            // Sjekker om det er TLS-feil og verdt å sende nytt kall
            if attempt < maxAttempts && shouldRetry(error: error) {
                let delay = calculateBackoff(attempt: attempt)
                print("Forsøk \(attempt) feilet. Prøver igjen om \(delay)s...")
                
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                await fetchWithRetry(url: url, query: query, attempt: attempt + 1, maxAttempts: maxAttempts)
            } else {
                print("*****Feil ved henting av data (forsøk \(attempt)/\(maxAttempts)): \(error)*****")
                // Eventuelt vis feilmelding til bruker her
            }
        }
    }
        
    
    
    
    
    
    private func shouldRetry(error: Error) -> Bool {
        // Retryer på nettverksfeil og TLS-feil, men ikke på dekodingsfeil
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut, .cannotConnectToHost, .networkConnectionLost,
                 .notConnectedToInternet, .secureConnectionFailed, .serverCertificateUntrusted:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    // Gir serveren/nettverk tid til å bli stabilt igjen, for å forhindre at det spammes med kall.
    private func calculateBackoff(attempt: Int) -> Double {
        // Eksponensiell backoff: 0.2s, 0.4s, 0.8s, 1.6s osv...
        return pow(2.0, Double(attempt - 1)) * 0.2
    }
    
    
    
    
    
    func velgForslag(firma: Firma) {
        self.query = firma.navn
        self.forslag = []
    }
}
