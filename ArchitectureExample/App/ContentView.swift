//
//  ContentView.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(CurrentUserViewModel.self) var currentUserViewModel
    
    var body: some View {
        Text("Hello, \(currentUserViewModel.name)")
    }
}
