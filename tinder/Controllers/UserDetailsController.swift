//
//  UserDetailsController.swift
//  tinder
//
//  Created by Mustafa Khalil on 6/16/19.
//

import UIKit

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    fileprivate let swipingHeightConstant: CGFloat = 30
    lazy var frameWidth = view.frame.width
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.delegate = self
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    
    let swipeImagePageController: SwipeImagePageController = {
        let iv = SwipeImagePageController()
        return iv
    }()
    
    let infoLabel: UILabel = {
        let info = UILabel()
        info.text = "A very very long statment that i don't know what i would do with"
        info.numberOfLines = 0
        return info
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismissButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var containerView: UIView = {
        return UIView()
    }()
    
    lazy var dislikeButton = createButtons(image: #imageLiteral(resourceName: "54797469-b618-491f-88e9-2824221065a6"), selector: #selector(dislike))
    lazy var superLikeButton = createButtons(image: #imageLiteral(resourceName: "b20a6d9a-233e-46da-bf38-96fdb801b723"), selector: #selector(dislike))
    lazy var likeButton = createButtons(image: #imageLiteral(resourceName: "49eda04c-035b-475c-bf42-c30a344445f5"), selector: #selector(dislike))
    
    fileprivate func createButtons(image: UIImage, selector: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }
    
    var user: CardViewModel
    
    init(user: CardViewModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeImagePageController.images = user.imageNames
        setupUI()
        setupVisualBlur()
        setupButtonBar()
        infoLabel.attributedText = user.attString
        infoLabel.textColor = .black
    }
    
    @objc func handleTapDismiss() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func dislike() {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y + swipingHeightConstant
        var change = frameWidth + changeY * 2
        change = max(change, frameWidth)
        let profileImageView = swipeImagePageController.view!
        profileImageView.frame = CGRect(x: min(0, -changeY), y: min(swipingHeightConstant, -changeY), width: change, height: change)
        profileImageView.center.x = scrollView.center.x
    }
    
    fileprivate func setupButtonBar() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.spacing = -32
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    fileprivate func setupVisualBlur() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchorinSuperView(disregarding: .bottom)
        visualEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        let swipingView = swipeImagePageController.view!
    
        scrollView.addSubview(swipingView)
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(dismissButton)
        
        scrollView.fillSuperview()
        dismissButton.anchor(top: swipingView.bottomAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: -25,
                                            left: 0,
                                            bottom: 0,
                                            right: 24),
                             size: .init(width: 50,
                                         height: 50))
        
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let profileImageView = swipeImagePageController.view!
        profileImageView.frame = CGRect(x: 0, y: swipingHeightConstant, width: frameWidth, height: frameWidth)
    }
}
