//
//  PlayerView.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//

import SwiftUI

struct PlayerView: View {
    let player: RadioPlayer

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
            .frame(minWidth: 320, minHeight: 400)
            .navigationTitle("Radio Online")
        }
    }
}

#Preview {
    PlayerView(player: RadioPlayer())
}
