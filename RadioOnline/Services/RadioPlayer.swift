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
    var nowPlaying: String?
    private var metadataDelegate: MetadataDelegate?
    
    
    func play(station: Station) {
        currentStation = station
        nowPlaying = nil
        guard let url = URL(string: station.url) else { return }
        configureAudioSession()
        let item = AVPlayerItem(url: url)
        let delegate = MetadataDelegate { [weak self] titulo in
            Task { @MainActor in self?.nowPlaying = titulo }
        }
        metadataDelegate = delegate
        let output = AVPlayerItemMetadataOutput()   // ← nuevo
        output.setDelegate(delegate, queue: .main)  // ← nuevo
        item.add(output)
        player = AVPlayer(playerItem: item)
        //player = AVPlayer(url: url)
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
        nowPlaying = nil
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
        #if os(iOS)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
        } catch {
            print(error)
        }
        #endif
    }
}
