//
//  RootView.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//


import SwiftUI
import SwiftData

enum Seccion: Hashable {
    case reproductor, emisoras
}

struct RootView: View {
    @State private var player = RadioPlayer()
    @State private var seleccion: Seccion = .reproductor

    var body: some View {
        TabView(selection: $seleccion) {
            Tab("Reproductor", systemImage: "play.circle", value: .reproductor) {
                PlayerView(player: player)
            }
            Tab("Emisoras", systemImage: "radio", value: .emisoras) {
                CatalogView(player: player, seleccion: $seleccion)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    RootView().modelContainer(for: Station.self, inMemory: true)
}
