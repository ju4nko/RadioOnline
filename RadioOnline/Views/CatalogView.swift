//
//  CatalogView.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//


import SwiftUI
import SwiftData

struct CatalogView: View {
    @Environment(\.modelContext) private var context
    let player: RadioPlayer
    @Binding var seleccion: Seccion
    
    @State private var logos: [String: URL] = [:]
    private let radioBrowser = RadioBrowserService()
    private let columnas = [GridItem(.adaptive(minimum: 120), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columnas, spacing: 16) {
                    ForEach(RadioCatalogItem.all) { item in
                        Button {
                            let logo = urlLogo(item)?.absoluteString ?? item.imageURL
                            let nueva = Station(nombre: item.nombre, url: item.url, imageURL: logo)
                            context.insert(nueva)
                            player.play(station: nueva)
                            seleccion = .reproductor
                        } label: {
                            EmisoraCard(nombre: item.nombre, imageURL: urlLogo(item))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Emisoras")
            .task { await cargarLogos() }
        }
        
    }
    
    private func urlLogo(_ item: RadioCatalogItem) -> URL? {
        logos[item.nombre] ?? item.imageURL.flatMap { URL(string: $0) }
    }
    
    /// Pide los logos de todas las emisoras en paralelo.
    private func cargarLogos() async {
        let service = radioBrowser
        await withTaskGroup(of: (String, URL?).self) { group in
            for item in RadioCatalogItem.all {
                group.addTask { (item.nombre, await service.logoURL(paraNombre: item.nombre)) }
            }
            for await (nombre, url) in group {
                if let url { logos[nombre] = url }
            }
        }
    }
    
    private struct EmisoraCard: View {
        let nombre: String
        let imageURL: URL?
        
        var body: some View {
            VStack(spacing: 8) {
                AsyncImage(url: imageURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(nombre)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    CatalogView(player: RadioPlayer(), seleccion: .constant(.emisoras))
        .modelContainer(for: Station.self, inMemory: true)
}
