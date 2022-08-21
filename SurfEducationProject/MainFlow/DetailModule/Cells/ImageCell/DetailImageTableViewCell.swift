//
//  DetailImageTableViewCell.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import UIKit

class DetailImageTableViewCell: UITableViewCell {

    // MARK: - Views

    @IBOutlet private weak var cartImageView: UIImageView!

    // MARK: - Properties

    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                return
            }
            
            ImageLoader().loadImage(from: url) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self?.cartImageView.image = image
                    
                    case .failure(_):
                        self?.cartImageView.image = nil
                    }
                }
            }
        }
    }
    
    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        cartImageView.layer.cornerRadius = 12
        cartImageView.contentMode = .scaleAspectFill
    }

}
