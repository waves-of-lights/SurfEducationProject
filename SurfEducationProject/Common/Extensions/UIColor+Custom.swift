//
//  UIColor+Custom.swift
//  SurfEducationProject
//
//  Created by Nastya on 21.08.2022.
//

import UIKit

extension UIColor {
    class var grayLine: UIColor { UIColor(named: "GrayLine")! }
    class var grayBackground: UIColor { UIColor(named: "GrayBackground")! }
    class var grayPlaceholder: UIColor { UIColor(named: "GrayPlaceholder")! }
    class var redLine: UIColor { UIColor(named: "RedLine")! }
    class var errorView: UIColor { UIColor(named: "ErrorView")! }
    class var grayProfileTitle: UIColor { UIColor(named: "GrayProfileTitle")! }
    
    var resolvedColor: UIColor {
        guard let vc = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return self
        }
        return self.resolvedColor(with: vc.traitCollection)
    }
}
