//
//  CardView.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit

class CardView: UIView {
    
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "IMG_0292"))
    
    fileprivate let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
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
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if shouldDismiss {
                
                let translationLocation: CGFloat = gesture.translation(in: nil).x > 0 ? 1000 : -1000
                self.frame = CGRect(x: translationLocation, y: 0, width: self.frame.width, height: self.frame.height)
                
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
