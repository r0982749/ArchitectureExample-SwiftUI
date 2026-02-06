//
//  UserListView.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 06/02/2026.
//

import SwiftUI

struct UserListView: View {
    @State var userListViewModel = UserListViewModel()
    
    var body: some View {
        ForEach(userListViewModel.users, id: \.self) { user in
            
        }
    }
}
