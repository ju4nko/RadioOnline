//
//  Station.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//
import Foundation
import SwiftData

@Model
class Station {
    var nombre: String
    var url: String
    var favorita: Bool
    var imageURL: String?
    
    init(nombre: String, url: String, imageURL: String? = nil) {
        self.nombre = nombre
        self.url = url
        self.favorita = false
        self.imageURL = imageURL
    }
}

