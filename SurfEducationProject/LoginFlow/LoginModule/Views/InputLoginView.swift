//
//  InputLoginView.swift
//  SurfEducationProject
//
//  Created by Nastya on 21.08.2022.
//

import UIKit

final class InputLoginView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var hideShowPasswordButton: UIButton!
    
    var placeholder: String? {
        didSet {
            
            let font = UIFont.systemFont(ofSize: 16, weight: .regular)
            inputField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayPlaceholder, NSAttributedString.Key.font: font]
            )
        }
    }
    
    var keyboardType: UIKeyboardType? {
        didSet {
            if let type = keyboardType {
                inputField.keyboardType = type
            }
            inputField.isSecureTextEntry = inputField.keyboardType != .numberPad
            hideShowPasswordButton.isHidden = true
        }
    }
    
    var enteredValue: String? {
        inputField.text
    }
    
    var isErrorState: Bool {
        didSet {
            if isErrorState {
                lineView.backgroundColor = .redLine
                errorLabel.text = "Поле не может быть пустым"
            } else {
                lineView.backgroundColor = .grayLine
                errorLabel.text = nil
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        self.isErrorState = false
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.isErrorState = false
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        inputField.delegate = self
    }
}

extension InputLoginView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isErrorState = false
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false}
        
        if textField.keyboardType == .numberPad {
            if string.isEmpty && text == "+" {
                placeholderLabel.text = nil
            }
            
            textField.text = text.applyPatternOnNumbers(pattern: "+# (###) ### ##-##", replacementCharacter: "#")
        } else {
            hideShowPasswordButton.isHidden = ((textField.text?.isEmpty) == nil)
        }
        return true
    }
}

private extension InputLoginView {
    @IBAction func textChanged(_ sender: Any) {
        if let empty = inputField.text?.isEmpty, empty {
            placeholderLabel.text = nil
            hideShowPasswordButton.isHidden = true
        } else {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBAction func hideShowButtonTap(_ sender: UIButton) {
        hideShowPasswordButton.alpha = 1.0
        inputField.isSecureTextEntry = !inputField.isSecureTextEntry
        if inputField.isSecureTextEntry {
            hideShowPasswordButton.setImage(UIImage(named: "hide_password"), for: .normal)
        } else {
            hideShowPasswordButton.setImage(UIImage(named: "show_password"), for: .normal)
        }
    }
    
    @IBAction func hideShowButtonTapDown(_ sender: UIButton) {
        hideShowPasswordButton.alpha = 0.5
    }
}
