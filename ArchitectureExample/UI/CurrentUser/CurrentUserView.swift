//
//  CurrentUserView.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 06/02/2026.
//

import SwiftUI

struct CurrentUserView: View {
    @Environment(CurrentUserState.self) var currentUserState
    
    var body: some View {
        Text("Hello, \(currentUserState.user?.fullname ?? "Anonymous")")
    }
}
