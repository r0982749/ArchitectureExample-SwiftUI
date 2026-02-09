//
//  UserListState.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 06/02/2026.
//

import Foundation

@Observable
class UserListState {
    var users: [User] = []
    
    init(userService: UserServiceProtocol = ServiceProvider.makeUserService()) {
        Task {
            self.users = await userService.getUsers()
        }
    }
}

