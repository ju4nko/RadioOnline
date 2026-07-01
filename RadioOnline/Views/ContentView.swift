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
            VStack(spacing: 0) {
                if let station = player.currentStation {
                    VStack {
                        if let urlString = station.imageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()   // spinner mientras carga
                            }
                            .frame(width: 120, height: 120)
                        }
                        Text(station.nombre)
                            .font(.headline)
                        if player.isLoading {
                            HStack(spacing: 6) {
                                ProgressView()
                                Text("Cargando…")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Image(systemName: "waveform")
                                .font(.largeTitle)
                                .symbolEffect(.variableColor.iterative, isActive: player.isPlaying)
                        }
                        Button {
                            player.togglePlayPause()
                        } label: {
                            Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .padding()
                }
            }
            .frame(minWidth: 500, minHeight: 400)
            .navigationTitle("Radio Online")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        mostrandoCatalogo = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
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
