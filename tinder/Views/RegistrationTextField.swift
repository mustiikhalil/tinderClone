//
//  RegistrationTextField.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/20/18.
//

import UIKit

class RegistrationTextField: UITextField {
    
    fileprivate let padding: CGFloat
    // Gives a padding when the person is typing in the textfield
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    // Gives a padding for the text in the textfield when there is no editing
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    // returns the size of the object
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
