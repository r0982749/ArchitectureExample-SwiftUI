//
//  AppCoordinator.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 02/02/2026.
//

import SwiftUI
internal import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var name: String = "Tester"
    
    @ViewBuilder
    func rootView() -> some View {
        Text("Hello, \(name)!")
    }
}
