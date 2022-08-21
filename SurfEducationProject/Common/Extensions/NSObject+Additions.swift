//
//  UIApplication+Additions.swift
//  SurfEducationProject
//
//  Created by Nastya on 21.08.2022.
//

import Foundation

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
