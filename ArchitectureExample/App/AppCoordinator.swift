//
//  AppCoordinator.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 02/02/2026.
//

import SwiftUI

@MainActor
@Observable
final class AppCoordinator {
    var name: String = "Tester"
    
    @ViewBuilder
    func rootView() -> some View {
        Text("Hello, \(name)!")
    }
}
