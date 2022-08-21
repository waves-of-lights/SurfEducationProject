//
//  DesignableView.swift
//  SurfEducationProject
//
//  Created by Nastya on 10.08.2022.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        // override it for additional settings
    }
    
    // MARK: - Inspectable
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.resolvedColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.updateMasksToBounds()
        }
    }
    
    // MARK: - Shadow
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            layer.shadowColor = shadowColor.resolvedColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
            self.updateMasksToBounds()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            self.layer.shadowOffset = self.shadowOffset
        }
    }
    
    private func updateMasksToBounds() {
        self.layer.masksToBounds = self.cornerRadius > 0 && self.shadowRadius == 0
    }
    
    @objc private func didChangeTraitCollection() {
        let border = self.borderColor
        let shadow = self.shadowColor
        
        self.borderColor = border
        self.shadowColor = shadow
    }
}
