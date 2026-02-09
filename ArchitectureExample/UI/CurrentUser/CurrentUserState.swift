//
//  CurrentUserState.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import Foundation

@Observable
class CurrentUserState {
    var user: User? = nil
    
    init(userService: UserServiceProtocol = ServiceProvider.makeUserService()) {
        Task {
            self.user = await userService.getCurrentUser()
        }
    }
}
