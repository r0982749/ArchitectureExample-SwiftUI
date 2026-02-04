//
//  UserViewState.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import Foundation

struct UserViewState {
    let fullname: String

    init(user: User) {
        self.fullname = "\(user.firstname) \(user.lastname)"
    }
}
