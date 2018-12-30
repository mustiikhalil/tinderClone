//
//  UIStackView.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit

class HomeButtonControlsStackView: UIStackView {
    
    static func createButton(img: UIImage) -> UIButton {
        let b = UIButton(type: .system)
        b.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        return b
    }
    
    let refreshButton = createButton(img: #imageLiteral(resourceName: "be077009-7a36-471e-a50f-11a4e597829f"))
    let dislikeButton = createButton(img: #imageLiteral(resourceName: "54797469-b618-491f-88e9-2824221065a6"))
    let superlikeButton = createButton(img: #imageLiteral(resourceName: "b20a6d9a-233e-46da-bf38-96fdb801b723"))
    let likeButton = createButton(img: #imageLiteral(resourceName: "49eda04c-035b-475c-bf42-c30a344445f5"))
    let specialButton = createButton(img: #imageLiteral(resourceName: "4d860822-2a26-42ed-91f0-9a971494ffdd"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        [refreshButton, dislikeButton, superlikeButton, likeButton, specialButton].forEach { (v) in
            addArrangedSubview(v)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
