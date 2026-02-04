//
//  UserMapper.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import Foundation

struct UserMapper {
    func getDTOFromJson(_ json: String) -> UserDTO? {
        do {
            let user = try getUserFromJson(json)
            
            return map(from: user)
        }
        catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    func map(from user: User) -> UserDTO {
        return UserDTO(firstname: user.firstname, lastname: user.lastname)
    }
    
    private func getUserFromJson(_ json: String) throws -> User {
        return try JSONDecoder().decode(User.self, from: Data(json.utf8))
    }
}
