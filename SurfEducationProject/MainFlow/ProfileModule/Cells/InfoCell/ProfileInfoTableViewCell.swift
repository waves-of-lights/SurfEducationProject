//
//  ProfileInfoTableViewCell.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

struct ProfileInfoItem: ProfileScreenProtocol {
    let type: ProfileScreenCellType
    let title: String?
    var subtitle: String?
    
    init(type: ProfileScreenCellType, subtitle: String) {
        self.type = type
        self.subtitle = subtitle
        switch type {
        case .address: title = "Город"
        case .email: title = "Почта"
        
        case .phone:
            title = "Телефон"
            self.subtitle = subtitle.applyPatternOnNumbers(pattern: "+# (###) ### ##-##", replacementCharacter: "#")
        
        default:
            title = ""
            break
        }
        
    }
}

final class ProfileInfoTableViewCell: ProfileScreenBaseCell {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: - Public
    override var model: ProfileScreenProtocol? {
        didSet {
            if let innerModel = model as? ProfileInfoItem {
                titleLabel.text = innerModel.title
                subtitleLabel.text = innerModel.subtitle
            }
        }
    }
}
