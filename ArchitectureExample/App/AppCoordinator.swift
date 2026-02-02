//
//  AppCoordinator.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 02/02/2026.
//

import SwiftUI

@MainActor
final class AppCoordinator {
    @ViewBuilder
    func rootView() -> some View {
        Text("Hello, World!")
    }
}
