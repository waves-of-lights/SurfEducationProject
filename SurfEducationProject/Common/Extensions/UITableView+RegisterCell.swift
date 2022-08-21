//
//  UITableView+RegisterCell.swift
//  SurfEducationProject
//
//  Created by Nastya on 21.08.2022.
//

import UIKit

extension UITableView {
    func registerCell(with type: UITableViewCell.Type) {
        self.register(UINib(nibName: type.nameOfClass, bundle: nil), forCellReuseIdentifier: type.nameOfClass)
    }
}
