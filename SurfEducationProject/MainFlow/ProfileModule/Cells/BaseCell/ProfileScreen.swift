//
//  ProfileScreen.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation

protocol ProfileScreenProtocol {
    var type: ProfileScreenCellType { get }
}

enum ProfileScreenCellType {
    case name
    case address
    case phone
    case email
}
