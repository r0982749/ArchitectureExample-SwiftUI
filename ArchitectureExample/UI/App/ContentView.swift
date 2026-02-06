//
//  ContentView.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                CurrentUserView()
            }
            Tab("Users", systemImage: "list.bullet") {
                UserListView()
            }
        }
    }
}
