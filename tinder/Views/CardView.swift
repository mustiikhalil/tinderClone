//
//  CardView.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit

class CardView: UIView {
    
    fileprivate let threshold: CGFloat = 100
    
    var cardViewModel: CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageName)
            infoLabel.attributedText = cardViewModel.attString
            infoLabel.textAlignment = cardViewModel.textAlligment
        }
    }
    
    // UI
    fileprivate var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    fileprivate var infoLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // removes all the subviews animations when doing the drag and drop animation.
            superview?.subviews.forEach({ (view) in
                view.layer.removeAllAnimations()
            })
        case .ended:
            handleEnded(gesture)
        case .changed:
            handleChange(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        
        let degrees: CGFloat = translation.x / 20
        let angel = degrees * .pi / 188
        let roataionalTransformation = CGAffineTransform(rotationAngle: angel)
        self.transform = roataionalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let shouldDismiss = abs(gesture.translation(in: nil).x) > threshold ? true : false
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if shouldDismiss {
                let translationLocation: CGFloat = gesture.translation(in: nil).x > 0 ? 600 : -600
                self.frame = CGRect(x: translationLocation, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            
            if shouldDismiss {
                self.removeFromSuperview()
            }
        }
    }
    
    //MARK:- UI FUNCTIONS
    
    override func layoutSubviews() {
        gradientLayer.frame = frame
    }
    
    fileprivate func setupView() {
        addSubview(imageView)
        
        // adding the gradient layer since the layer needs to be before infolabel
        setupGradientLayer()
        addSubview(infoLabel)
        layer.cornerRadius = 10
        clipsToBounds = true
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.numberOfLines = 0
        imageView.fillSuperview()
    }
    
    fileprivate func setupGradientLayer() {
        // setup the gradient layer colors
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        // where to start the layer
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
