//
//  AuthResponseModel.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation

struct AuthResponseModel {

    let token: String?
    let userInfo: UserInfo?
}

extension AuthResponseModel: Decodable {
    enum UserCodingKeys: String, CodingKey {
        case userInfo = "user_info"
        case token
    }
    
    init(from decoder: Decoder) throws {
        let userContainer = try decoder.container(keyedBy: UserCodingKeys.self)
        userInfo = try userContainer.decodeIfPresent(UserInfo.self, forKey: .userInfo)
        token = try userContainer.decodeIfPresent(String.self, forKey: .token)
    }
}


struct UserInfo: Codable {
    let id: String
    let phone: String
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    let city: String
    let about: String
}
