//
//  RadioOnlineApp.swift
//  RadioOnline
//
//  Created by Juanjo on 01/07/2026.
//

import SwiftUI
import SwiftData

@main
struct RadioOnlineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Station.self)
        }
    }
}
