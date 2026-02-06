//
//  UserListItemPartialView.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 06/02/2026.
//

import SwiftUI

struct UserListItemPartialView: View {
    let user: User
    
    var body: some View {
        Text("\(user.fullname)")
    }
}
