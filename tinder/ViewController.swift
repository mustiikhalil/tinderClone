//
//  ViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit

class ViewController: UIViewController {
    
    private let cardDeckView = UIView()
    private let topView = TopNavigationStackView()
    private let bottomStackView = HomeButtonControlsStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        let cardView = CardView(frame: .zero)
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    //MARK:- FilePrivate

    fileprivate func setupLayout() {
        let mainStackView = UIStackView(arrangedSubviews: [topView, cardDeckView, bottomStackView])
        mainStackView.axis = .vertical
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        mainStackView.bringSubviewToFront(cardDeckView)
    }

}

