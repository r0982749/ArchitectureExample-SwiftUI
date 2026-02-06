//
//  User.swift
//  ArchitectureExample
//
//  Created by Lars Coppieters on 04/02/2026.
//

import Foundation

struct User: Hashable {
    let firstname: String
    let lastname: String
    var fullname: String { "\(firstname) \(lastname)" }
}
