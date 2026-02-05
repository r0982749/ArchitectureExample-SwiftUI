//
//  UserMapper.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import Foundation

struct UserMapper {
    func getUserFromJson(_ json: String) -> User? {
        do {
            let userDTO = try getUserDTOFromJson(json)
            
            return map(from: userDTO)
        }
        catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    func map(from userDTO: UserDTO) -> User {
        return User(firstname: userDTO.firstname, lastname: userDTO.lastname)
    }
    
    private func getUserDTOFromJson(_ json: String) throws -> UserDTO {
        return try JSONDecoder().decode(UserDTO.self, from: Data(json.utf8))
    }
}
