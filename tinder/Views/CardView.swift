//
//  CardView.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit
import SDWebImage

protocol CardViewProtocol {
    func shouldPresentDetailsFor()
}

class CardView: UIView {
    
    fileprivate let threshold: CGFloat = 100
    fileprivate let deselectedColor = UIColor(white: 0, alpha: 0.1)
    fileprivate var delegate: CardViewProtocol?
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            setupImage(url: imageName)
            infoLabel.attributedText = cardViewModel.attString
            infoLabel.textAlignment = cardViewModel.textAlligment
            setupbars()
            setupImageIndexObserver()
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
    fileprivate let barsStackView = UIStackView()
    
    fileprivate lazy var moreInfoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "info").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(presentDetailsPage), for: .touchUpInside)
        return btn
    }()
    
    init(delegate: CardViewProtocol) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    //MARK:- MVVM
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [unowned self] (imgURL, index) in
            self.setupImage(url: imgURL ?? "")
            self.barsStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self.deselectedColor
            }
            self.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate func setupImage(url imgUrl: String) {
        if let url = URL(string: imgUrl) {
            imageView.sd_setImage(with: url)
        }
    }
    
    //MARK:-GESTURES
    
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
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    @objc func presentDetailsPage() {
        delegate?.shouldPresentDetailsFor()
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
        setupBarStackView()
        addSubview(infoLabel)
        layer.cornerRadius = 10
        clipsToBounds = true
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.numberOfLines = 0
        imageView.fillSuperview()
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupBarStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    fileprivate func setupbars() {
        cardViewModel.imageNames.forEach { (_) in
            let v = UIView()
            v.backgroundColor = deselectedColor
            barsStackView.addArrangedSubview(v)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
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
