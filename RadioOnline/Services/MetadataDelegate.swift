//
//  MetadataDelegate.swift
//  RadioOnline
//
//  Created by Juanjo on 02/07/2026.
//
import AVFoundation

final class MetadataDelegate: NSObject, AVPlayerItemMetadataOutputPushDelegate {
    private let onTitle: (String?) -> Void
    
    init(onTitle: @escaping (String?) -> Void) {
        self.onTitle = onTitle
    }
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput,
                          didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup],
                        from track: AVPlayerItemTrack?) {
        let items = groups.flatMap { $0.items }
        guard let item = items.first(where: { $0.identifier == .icyMetadataStreamTitle })
            ?? items.first(where: { $0.commonKey == .commonKeyTitle }) else {
            onTitle(nil)
            return
        }
        Task {
            let titulo = try? await item.load(.stringValue)
            let limpio = titulo?.trimmingCharacters(in: .whitespacesAndNewlines)
            onTitle(limpio?.isEmpty == false ? limpio : nil)
        }
        
    }
}
