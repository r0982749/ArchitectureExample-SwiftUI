//
//  UserServiceProtocol.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 09/02/2026.
//

import Foundation

protocol UserServiceProtocol {
    func getCurrentUser() async -> User?
    
    func getUsers() async -> [User]
}
