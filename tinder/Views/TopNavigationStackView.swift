//
//  TopNavigationStackView.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit


class TopNavigationStackView: UIStackView {
    
    let settingIcon = UIButton(type: .system)
    let flameIcon = UIImageView(image: #imageLiteral(resourceName: "ae0aee87-ff7a-4830-94d3-6f19bb64dee3"))
    let messageIcon = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flameIcon.contentMode = .scaleAspectFit
        settingIcon.setImage(#imageLiteral(resourceName: "208322b9-6bf3-4241-9cec-17a73e689bac").withRenderingMode(.alwaysOriginal), for: .normal)
        messageIcon.setImage(#imageLiteral(resourceName: "9474f3a4-dd2f-4cb9-a225-cb108e4aaeda").withRenderingMode(.alwaysOriginal), for: .normal)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
      
        [settingIcon, UIView(), flameIcon, UIView(), messageIcon].forEach { (v) in
            addArrangedSubview(v)
        }
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

