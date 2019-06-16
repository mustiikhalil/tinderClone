//
//  UserDetailsController.swift
//  tinder
//
//  Created by Mustafa Khalil on 6/16/19.
//

import UIKit

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    lazy var frameWidth = view.frame.width
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .green
        scroll.alwaysBounceVertical = true
        scroll.delegate = self
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "IMG_0292")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoLabel: UILabel = {
        let info = UILabel()
        info.text = "A very very long statment that i don't know what i would do with"
        info.numberOfLines = 0
        return info
    }()
    
    lazy var containerView: UIView = {
        return UIView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(containerView)
        containerView.fillSuperview()
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerView.addSubview(profileImageView)
        containerView.addSubview(infoLabel)
        profileImageView.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameWidth)
        infoLabel.anchor(top: profileImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc func handleTapDismiss() {
        dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var change = frameWidth + changeY * 2
        change = max(change, frameWidth)
        profileImageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: change, height: change)
        profileImageView.center.x = scrollView.center.x
    }
}
