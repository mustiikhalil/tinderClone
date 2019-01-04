//
//  SettingsCell.swift
//  tinder
//
//  Created by Mustafa Khalil on 1/4/19.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let textField: SettingsTextField = {
        let tf = SettingsTextField()
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingsTextField: UITextField {
    private let padding: CGFloat = 24
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
}

