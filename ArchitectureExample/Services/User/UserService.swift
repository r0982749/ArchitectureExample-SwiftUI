//
//  UserService.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 09/02/2026.
//

import Foundation

actor UserService: UserServiceProtocol {
    func getCurrentUser() async -> User? {
        return nil
    }
    
    func getUsers() async -> [User] {
        return []
    }
}
