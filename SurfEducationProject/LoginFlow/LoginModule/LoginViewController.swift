//
//  LoginViewController.swift
//  SurfEducationProject
//
//  Created by Nastya on 21.08.2022.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var loginField: InputLoginView!
    @IBOutlet private weak var passwordField: InputLoginView!
    @IBOutlet private weak var loginButton: LoadingButton!
    
    // MARK: - Pablic
    var onFinish: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вход"
        configureViews()
    }
}

// MARK: - Private extensions
private extension LoginViewController {
    func configureViews() {
        loginField.keyboardType = .numberPad
        loginField.placeholder = "Логин"
        passwordField.keyboardType = .default
        passwordField.placeholder = "Пароль"
        loginButton.setTitle("Войти", for: .normal)
    }
}

// MARK: - Actions
private extension LoginViewController {
    @IBAction func loginAction(_ sender: UIButton) {
        view.endEditing(true)
        
        if let login = loginField.enteredValue, let password = passwordField.enteredValue, !login.isEmpty, !password.isEmpty {
            var clearLogin = login.replacingOccurrences(of: "(", with: "")
            clearLogin = clearLogin.replacingOccurrences(of: ")", with: "")
            clearLogin = clearLogin.replacingOccurrences(of: "-", with: "")
            clearLogin = clearLogin.replacingOccurrences(of: " ", with: "")
            let model = AuthRequestModel(phone: clearLogin, password: password)
            loginButton.showLoading()
            AuthService().performLoginRequestAndSaveToken(credentials: model) { [weak self] result in
                DispatchQueue.main.async {
                    self?.loginButton.hideLoading()
                    switch result {
                    case .success(let result):
                        if let info = result.userInfo {
                            
                            do {
                                let encoder = JSONEncoder()
                                let data = try encoder.encode(info)
                                UserDefaults.standard.set(data, forKey: "user_info")
                                
                            } catch {
                                print("Unable to Encode (\(error))")
                            }
                        }
                        
                        self?.onFinish?()
                    case .failure:
                        FloatingNotificationViewFactory.error(on: self, title: "Логин или пароль введен неправильно")
                    }
                }
            }
        } else {
            loginField.isErrorState = ((loginField.enteredValue?.isEmpty) != nil)
            passwordField.isErrorState = ((passwordField.enteredValue?.isEmpty) != nil)
        }
    }
}
