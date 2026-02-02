//
//  ArchitectureExampleApp.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 02/02/2026.
//

import SwiftUI

@main
struct ArchitectureExampleApp: App {
    @State private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.rootView()
        }
    }
}
