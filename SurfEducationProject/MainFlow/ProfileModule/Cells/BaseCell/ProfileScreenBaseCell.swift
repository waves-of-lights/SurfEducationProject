//
//  ProfileScreenBaseCell.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

class ProfileScreenBaseCell: UITableViewCell {
    
    // MARK: - Public
    var model: ProfileScreenProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .white
        backgroundColor = .white
    }
}
