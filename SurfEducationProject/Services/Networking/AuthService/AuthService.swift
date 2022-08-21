//
//  AuthService.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.//

import Foundation

struct AuthService {

    let dataTask = BaseNetworkTask<AuthRequestModel, AuthResponseModel>(
        inNeedInjectToken: false,
        method: .post,
        path: "auth/login"
    )

    func performLoginRequestAndSaveToken(
        credentials: AuthRequestModel,
        _ onResponseWasReceived: @escaping (_ result: Result<AuthResponseModel, Error>) -> Void
    ) {
        dataTask.performRequest(input: credentials) { result in
            if case let .success(responseModel) = result {
                do {
                    if let token = responseModel.token {
                        try dataTask.tokenStorage.set(newToken: TokenContainer(token: token, receivingDate: .now))
                    }
                    
                } catch {
                   // TODO: - Handle error if token not was received from server
                }
            }

            onResponseWasReceived(result)
        }
    }

}
