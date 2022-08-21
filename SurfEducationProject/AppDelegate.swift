//
//  AppDelegate.swift
//  SurfEducationProject
//
//  Created by Nastya on 02.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let configurator = TabBarConfigurator()
    var  window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let savedToken = try? BaseTokenStorage().getToken()
        if let token = savedToken, !token.isExpired {
            goToMain()
        } else {
            goToLogin()
        }
        
        window?.makeKeyAndVisible()
        return true
    }

    func goToMain() {
        window?.rootViewController = configurator.configure()
        configurator.onFinish = { [weak self] in
            self?.goToLogin()
        }
    }
    
    func goToLogin() {
        let loginVC = LoginViewController()
        let navigationVC = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = navigationVC
        
        loginVC.onFinish = { [weak self] in
            self?.goToMain()
        }
    }
}

