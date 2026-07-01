//
//  RadioPlayer.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//
import Foundation
import AVFoundation
import Observation

@Observable
class RadioPlayer {
    private var player: AVPlayer?
    var isPlaying: Bool = false
    var currentStation: Station?
    var isLoading: Bool = false
    private var statusObservation: NSKeyValueObservation?
    
    
    func play(station: Station) {
        currentStation = station
        guard let url = URL(string: station.url) else { return }
        configureAudioSession()
        player = AVPlayer(url: url)
        statusObservation = player?.observe(\.timeControlStatus) { [weak self] player, _ in
            guard let self else { return }
            let isLoading = (player.timeControlStatus == .waitingToPlayAtSpecifiedRate)
            Task { @MainActor in
                self.isLoading = isLoading
            }
        }
        player?.play()
        isPlaying = true
    }
    
    func stop() {
        player?.pause()
        player = nil
        currentStation = nil
        isPlaying = false
    }
    
    func togglePlayPause() {
        guard player != nil else { return }
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
        } catch {
            print(error)
        }
        
    }
}
