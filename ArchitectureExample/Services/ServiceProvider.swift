//
//  ServiceProvider.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 09/02/2026.
//

import Foundation

enum ServiceProvider {
    static func makeUserService() -> UserServiceProtocol {
        UserService()
    }
}
