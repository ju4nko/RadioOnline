//
//  RadioBrowserService.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//

import Foundation

/// Consulta el directorio abierto Radio Browser para obtener el logo (favicon) de una emisora.
struct RadioBrowserService {
    private let base = "https://all.api.radio-browser.info"

    /// Devuelve la URL del logo de la emisora que mejor coincide con `nombre`, o nil.
    func logoURL(paraNombre nombre: String) async -> URL? {
        guard let encoded = nombre.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let endpoint = URL(string: "\(base)/json/stations/byname/\(encoded)") else {
            return nil
        }

        var request = URLRequest(url: endpoint)
        request.setValue("RadioOnline/1.0", forHTTPHeaderField: "User-Agent")   // la API lo recomienda

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let stations = try JSONDecoder().decode([RadioBrowserStation].self, from: data)
            // Mejor candidato: que tenga favicon y sea el más votado.
            let mejor = stations
                .filter { !$0.favicon.isEmpty }
                .max { $0.votes < $1.votes }
            return mejor.flatMap { URL(string: $0.favicon) }
        } catch {
            print("RadioBrowser error:", error)
            return nil
        }
    }
}

private struct RadioBrowserStation: Decodable {
    let name: String
    let favicon: String
    let votes: Int
}
