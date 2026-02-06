//
//  CurrentUserView.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 06/02/2026.
//

import SwiftUI

struct CurrentUserView: View {
    @Environment(CurrentUserViewModel.self) var currentUserViewModel
    
    var body: some View {
        Text("Hello, \(currentUserViewModel.user?.fullname ?? "Anonymous")")
    }
}
