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
                    VStack(spacing: 16) {
                        Spacer()
                        if let urlString = station.imageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView()   // spinner mientras carga
                            }
                            .frame(width: 220, height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 12, y: 6)
                        }
                        Text(station.nombre)
                            .font(.title2)
                            .bold()
                        
                        if let programa = player.nowPlaying {
                            Text(programa)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .transition(.opacity)
                        }
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
                        HStack(spacing: 30) {
                            Button {
                                player.togglePlayPause()
                            } label: {
                                Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 64, height: 64)
                            }
                            Button {
                                player.stop()
                            } label: {
                                Image(systemName: "stop.circle.fill")
                                    .resizable()
                                    .frame(width: 64, height: 64)
                            }
                        }
                        
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        if let urlString = station.imageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: { Color.clear }
                            .blur(radius: 40)
                            .opacity(0.5)
                            .overlay(.ultraThinMaterial)   // capa translúcida para que el texto se lea
                            .ignoresSafeArea()
                        }
                    }
                    .padding()
                } else {
                    ContentUnavailableView("Sin emisora", systemImage: "radio",
                                           description: Text("Elige una emisora en la pestaña Emisoras."))
                }
                
            }
            .animation(.default, value: player.nowPlaying)
            .frame(minWidth: 320, minHeight: 400)
            .navigationTitle("Radio Online")
        }
    }
}

#Preview {
    PlayerView(player: RadioPlayer())
}
