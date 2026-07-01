//
//  ContentView.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    @Query private var stations: [Station]
    @Environment(\.modelContext) private var context
    @State private var player = RadioPlayer()
    @State private var mostrandoCatalogo = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let station = player.currentStation {
                    if let urlString = station.imageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()   // spinner mientras carga
                        }
                        .frame(width: 120, height: 120)
                        Text(station.nombre)
                            .font(.headline)
                        Image(systemName: "waveform")
                            .font(.largeTitle)
                            .symbolEffect(.variableColor.iterative, isActive: player.isPlaying)
                        Button {
                            player.togglePlayPause()
                        } label: {
                            Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                }
            }
            .navigationTitle("Emisora")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        mostrandoCatalogo = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        player.stop()
                    } label: {
                        Image(systemName: "stop.fill")
                    }
                }
            }
            .sheet(isPresented: $mostrandoCatalogo) {
                CatalogView(player: player)
            }
        }
    }
}

#Preview {
    ContentView().modelContainer(for: Station.self, inMemory: true)
}
