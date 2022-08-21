//
//  TabBarConfigurator.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation
import UIKit

final class TabBarConfigurator {

    // MARK: - Private property

    private let allTab: [TabBarModel] = [.main, .favorite, .profile]
    
    private let model: MainModel  = .init()
    
    // MARK: - Public
    var onFinish: (() -> Void)?

    // MARK: - Internal Methods

    func configure() -> UITabBarController {
        return getTabBarController()
    }
}

// MARK: - Private Methods

private extension TabBarConfigurator {

    func getTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.viewControllers = getViewControllers()

        return tabBarController
    }

    func getViewControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()

        allTab.forEach { tab in
            let controller = getCurrentViewController(tab: tab)
            let navigationController = UINavigationController(rootViewController: controller)
            let tabBarItem = UITabBarItem(title: tab.title, image: tab.image, selectedImage: tab.selectedImage)
            controller.tabBarItem = tabBarItem
            viewControllers.append(navigationController)
        }

        return viewControllers
    }

    func getCurrentViewController(tab: TabBarModel) -> UIViewController {
        
        switch tab {
        case .main:
            let mainViewController = MainViewController()
            mainViewController.model = model
            return mainViewController
        case .favorite:
            let favoriteViewController = FavoriteViewController()
            favoriteViewController.model = model
            return favoriteViewController
        case .profile:
            let profile = ProfileViewController()
            profile.onFinish = { [weak self] in
                self?.onFinish?()
            }
            return profile
        }
    }

}
