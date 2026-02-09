//
//  ServiceProvider.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 09/02/2026.
//

import Foundation

enum ServiceProvider {
    func makeUserService() -> UserServiceProtocol {
        UserService()
    }
}
