//
//  UserService.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 09/02/2026.
//

import Foundation

actor UserService: UserServiceProtocol {
    func getCurrentUser() async -> User? {
        // Json should come from the Util layer
        return await UserMapper().getUserFromJson("{ \"firstname\": \"Testing\", \"lastname\": \"Tester\" }")
    }
    
    func getUsers() async -> [User] {
        // Json should come from the Util layer
        return await UserMapper().getUsersFromJson("[ { \"firstname\": \"Testing\", \"lastname\": \"Tester\" }, { \"firstname\": \"Tester\", \"lastname\": \"Test\" } ]")
    }
}
