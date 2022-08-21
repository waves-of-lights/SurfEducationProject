//
//  TokenStorage.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation

protocol TokenStorage {

    func getToken() throws -> TokenContainer
    func set(newToken: TokenContainer) throws

}
