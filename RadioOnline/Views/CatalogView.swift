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

    var body: some View {
        NavigationStack {
            List(RadioCatalogItem.all) { item in
                Button {
                    let nueva = Station(nombre: item.nombre, url: item.url, imageURL: item.imageURL)
                    context.insert(nueva)
                    player.play(station: nueva)
                    seleccion = .reproductor          // salta a la pestaña del reproductor
                } label: {
                    Text(item.nombre)
                }
            }
            .navigationTitle("Emisoras")
        }
    }
}

#Preview {
    CatalogView(player: RadioPlayer(), seleccion: .constant(.emisoras))
        .modelContainer(for: Station.self, inMemory: true)
}
