//
//  CurrentUserViewModel.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import Foundation

@Observable
class CurrentUserViewModel {
    var user: User? = nil
    
    init() {
        // To be replaced by a call to the service
        self.user = UserMapper().getUserFromJson("{ \"firstname\": \"Testing\", \"lastname\": \"Tester\" }")
    }
}
