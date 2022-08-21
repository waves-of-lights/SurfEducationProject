//
//  FloatingNotificationView.swift
//  FlowHealth
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

class FloatingNotificationView: UIView {
    
    static let didTapNotificationName = Notification.Name(rawValue: "FloatingNotificationViewDidTap")
    
    enum Position {
        case top
        case bottom
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: DesignableView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Public
    var containerColor: UIColor? {
        didSet {
            self.containerView.backgroundColor = self.containerColor
        }
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    var offset: CGFloat = 0
    var position: Position = .bottom
    var userInfo: Any? = nil
    
    // MARK: - Private
    private var isInteracting = false
    private var showTime = 3.0
    
    private var offsetConstraint: NSLayoutConstraint!
    private var timeToHideTimer: Timer?
    private let createdAt = Date()
    
    private var timeToHide: Date? {
        didSet {
            guard let time = self.timeToHide else {
                return
            }
            
            let delay = time.timeIntervalSince(Date())
            
            if delay > 0 {
                self.timeToHideTimer?.invalidate()
                self.timeToHideTimer = Timer.scheduledTimer(timeInterval: delay,
                                                            target: self,
                                                            selector: #selector(tryToHide),
                                                            userInfo: nil,
                                                            repeats: false)
            } else {
                self.hide()
            }
        }
    }
    
    // MARK: - Public
    class func instance(position: Position = .bottom) -> Self {
        // Load view from xib and add it to window
        let name = Self.nameOfClass
        let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)!.first as! Self
        view.translatesAutoresizingMaskIntoConstraints = false
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(view)
        
        let views = ["view": view]
        var constraints: [NSLayoutConstraint] = []
        constraints.append(self.constraint(with: "H:|-0-[view]", views: views))
        constraints.append(self.constraint(with: "H:[view]-0-|", views: views))
        switch position {
        case .bottom:
            constraints.append(self.constraint(with: "V:[view]-0-|", views: views))
        case .top:
            constraints.append(self.constraint(with: "V:|-0-[view]", views: views))
            
        }
        
        NSLayoutConstraint.activate(constraints)
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: 100)
        view.addConstraints([heightConstraint])

        // Set up notificationView
        constraints.last?.constant = -view.bounds.size.height
        view.offsetConstraint = constraints.last
        return view
    }
    
    
    func show() {
        self.timeToHide = Date(timeIntervalSinceNow: self.showTime)
        self.offsetConstraint.constant = 0

        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { (_) in
            guard let subviews = self.superview?.subviews else {
                return
            }
            
            // Remove another push notification views - standard behaviour
            for case let view as Self in subviews {
                if view.createdAt < self.createdAt {
                    view.removeFromSuperview()
                }
            }
        })
    }
    
    func hide(duration: TimeInterval = 0.3) {
        let offset: CGFloat
        switch position {
        case .bottom:
            offset = superview?.safeAreaInsets.bottom ?? 0
        case .top:
            offset = 0
        }
        
        self.timeToHideTimer?.invalidate()
        self.offsetConstraint.constant = -self.bounds.size.height - offset
    
        UIView.animate(withDuration: duration, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Private
    static private func constraint(with format: String, views: [String: Any]) -> NSLayoutConstraint {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: views).first!
    }
    
    @objc private func tryToHide() {
        if !self.isInteracting {
            self.hide()
        }
    }
}
