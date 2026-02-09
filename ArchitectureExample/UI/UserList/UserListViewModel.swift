//
//  UserListViewModel.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 06/02/2026.
//

import Foundation

@Observable
class UserListViewModel {
    var users: [User] = []
    
    init(userService: UserServiceProtocol = ServiceProvider.makeUserService()) {
        
        
        
        // call to service
        self.users = [
            User(firstname: "Testing", lastname: "Tester"),
            User(firstname: "Tester", lastname: "Test"),
        ]
    }
}

