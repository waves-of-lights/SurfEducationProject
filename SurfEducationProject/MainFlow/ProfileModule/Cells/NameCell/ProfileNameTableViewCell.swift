//
//  ProfileNameTableViewCell.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

struct ProfileNameItem: ProfileScreenProtocol {
    var type: ProfileScreenCellType
    let avatarURLString: String
    let firstName: String
    let secondName: String
    let phrase: String
    
    init(type: ProfileScreenCellType,
         avatarURLString: String,
         firstName: String, secondName: String,
         phrase: String) {
        self.type = type
        self.avatarURLString = avatarURLString
        self.firstName = firstName
        self.secondName = secondName
        self.phrase = phrase
    }
}

final class ProfileNameTableViewCell: ProfileScreenBaseCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    
    override var model: ProfileScreenProtocol? {
        didSet {
            if let innerModel = model as? ProfileNameItem {
                firstNameLabel.text = innerModel.firstName
                secondNameLabel.text = innerModel.secondName
                phraseLabel.text = innerModel.phrase
                
                avatarImageView.layer.cornerRadius = 12
                
                guard let avatarURL = URL(string: innerModel.avatarURLString) else { return }
                avatarImageView.load(url: avatarURL, placeholder: nil) { [weak self] (image, innerUrl) in
                    if avatarURL.absoluteString == innerUrl.absoluteString {
                        self?.avatarImageView.image = image
                    }
                }
            }
        }
    }
}
