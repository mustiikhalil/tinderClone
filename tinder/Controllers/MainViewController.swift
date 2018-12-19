//
//  ViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit

class MainViewController: UIViewController {
    
    private let cardDeckView = UIView()
    private let topView = TopNavigationStackView()
    private let bottomStackView = HomeButtonControlsStackView()

    let cardViewModel: [CardViewModel] = {
        let produces = [
            Advertiser(title: "", brandName: "Order now", posterImageName: "ad"),
            User(name: "katie", age: 20, profession: "Student", imageNames: ["girl2", "girl2"]),
            User(name: "Sky", age: 24, profession: "Streamer", imageNames: ["IMG_0292", "sky2", "sky3"]),
            ] as [ProducesCardViewModel]
        
        return produces.map{ $0.toCardViewModel() }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        cardViewModel.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
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

