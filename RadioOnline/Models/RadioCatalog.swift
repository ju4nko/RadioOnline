//
//  RadioCatalog.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//
import Foundation

struct RadioCatalogItem: Identifiable {
    let id = UUID()
    let nombre: String
    let url: String
    let imageURL: String?
    
    static let all: [RadioCatalogItem] = [
        RadioCatalogItem(nombre: "Cadena SER", url: "https://playerservices.streamtheworld.com/api/livestream-redirect/CADENASER.mp3", imageURL: "https://picsum.photos/seed/ser/200"),
        RadioCatalogItem(nombre: "LOS40", url: "https://playerservices.streamtheworld.com/api/livestream-redirect/LOS40.mp3", imageURL: "https://picsum.photos/seed/ser/200"),
        RadioCatalogItem(nombre: "Cadena Dial", url: "https://playerservices.streamtheworld.com/api/livestream-redirect/CADENADIAL.mp3", imageURL: "https://picsum.photos/seed/ser/200"),
        RadioCatalogItem(nombre: "M80 Radio", url: "https://playerservices.streamtheworld.com/api/livestream-redirect/M80RADIO.mp3", imageURL: "https://picsum.photos/seed/ser/200")
    ]
}


