//
//  FloatingNotificationViewFactory.swift
//  SurfEducationProject
//
//  Created by Nastya on 10.08.2022.
//

import UIKit

enum FloatingNotificationViewType {
    case error
    case done
}

enum FloatingNotificationViewEvent {
    case none
}

class FloatingNotificationViewFactory {
    // MARK: - Public
    class func error(on viewController: UIViewController?,
                     error: Error,
                     position: FloatingNotificationView.Position = .top,
                     event: FloatingNotificationViewEvent = .none) {
        present(on: viewController, with: .error, title: error.localizedDescription, position: position, event: event)
    }
    
    class func error(on viewController: UIViewController?,
                     title: String,
                     position: FloatingNotificationView.Position = .top,
                     event: FloatingNotificationViewEvent = .none) {
        present(on: viewController, with: .error, title: title, position: position, event: event)
    }
    
    class func success(on viewController: UIViewController?,
                       title: String,
                       position: FloatingNotificationView.Position = .top,
                       event: FloatingNotificationViewEvent = .none) {
        present(on: viewController, with: .done, title: title, position: position, event: event)
    }
    
    class func custom(on viewController: UIViewController?,
                      title: String,
                      with type: FloatingNotificationViewType,
                      position: FloatingNotificationView.Position = .top,
                      event: FloatingNotificationViewEvent = .none) {
        present(on: viewController, with: type, title: title, position: position, event: event)
    }
    
    private class func present(on viewController: UIViewController?,
                               with type: FloatingNotificationViewType,
                               title: String,
                               position: FloatingNotificationView.Position = .bottom,
                               event: FloatingNotificationViewEvent = .none,
                               offset: CGFloat = 0) {
        guard let viewController = viewController else {
            return
        }
        
        var additionalOffset: CGFloat = 0
        
        switch position {
        case .top:
            additionalOffset = viewController.view.safeAreaInsets.top
        case .bottom:
            if let tabBarController = viewController.tabBarController ?? viewController as? UITabBarController {
                additionalOffset = tabBarController.tabBar.bounds.height
            } else {
                additionalOffset = viewController.view.safeAreaInsets.bottom
            }
        }
        
        additionalOffset += UIDevice.current.userInterfaceIdiom == .pad ? 24 : 0
        
        self.present(on: viewController.view,
                     with: type,
                     title: title,
                     position: position,
                     event: event,
                     offset: offset + additionalOffset)
    }
    
    private class func present(on parentView: UIView,
                               with type: FloatingNotificationViewType,
                               title: String,
                               position: FloatingNotificationView.Position = .bottom,
                               event: FloatingNotificationViewEvent = .none,
                               offset: CGFloat = 0) {
        switch type {
        case .error:
            self.errorFloatingNotificationView(title: title, position: position, event: event, offset: offset)
                .show()
        case .done:
            self.doneFloatingNotificationView(title: title, position: position, event: event, offset: offset)
                .show()
        }
    }
    
    // MARK: - Private
    private class func errorFloatingNotificationView(title: String,
                                                     position: FloatingNotificationView.Position = .bottom,
                                                     event: FloatingNotificationViewEvent = .none,
                                                     offset: CGFloat = 0) -> FloatingNotificationView {
        self.instance(title: title,
                      containerColor: .errorView,
                      position: position,
                      event: event,
                      offset: offset)
    }
    
    private class func doneFloatingNotificationView(title: String,
                                                    position: FloatingNotificationView.Position = .bottom,
                                                    event: FloatingNotificationViewEvent = .none,
                                                    offset: CGFloat = 0) -> FloatingNotificationView {
        self.instance(title: title,
                      containerColor: .errorView,
                      position: position,
                      event: event,
                      offset: offset)
    }
    
    private class func instance(title: String,
                                containerColor: UIColor? = nil,
                                position: FloatingNotificationView.Position = .bottom,
                                event: FloatingNotificationViewEvent = .none,
                                offset: CGFloat = 0) -> FloatingNotificationView {
        let view = FloatingNotificationView.instance(position: position)
        view.title = title
        view.containerColor = containerColor
        view.position = position
        view.offset = offset
        view.userInfo = event
        
        return view
    }
}
