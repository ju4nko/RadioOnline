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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(RadioCatalogItem.all) { item in
                Button {
                    let nueva = Station(nombre: item.nombre, url: item.url, imageURL: item.imageURL)
                    context.insert(nueva)
                    player.play(station: nueva)
                    dismiss()
                } label: {
                    Text(item.nombre)
                }
            }
            .navigationTitle("Añadir emisora")
        }
    }
}

#Preview {
    CatalogView(player: RadioPlayer())
}
