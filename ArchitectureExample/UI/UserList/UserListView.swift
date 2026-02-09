//
//  UserListView.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 06/02/2026.
//

import SwiftUI

struct UserListView: View {
    @State var userListState = UserListState()
    
    var body: some View {
        VStack {
            List(userListState.users, id: \.self) { user in
                UserListItemPartialView(user: user)
            }
        }
    }
}
