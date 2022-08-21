//
//  NetworkMethod.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation

enum NetworkMethod: String {

    case get
    case post

}

extension NetworkMethod {

    var method: String {
        rawValue.uppercased()
    }

}
