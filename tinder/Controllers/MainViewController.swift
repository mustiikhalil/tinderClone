//
//  ViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit
import Firebase
import JGProgressHUD

class MainViewController: UIViewController {
    
    private let cardDeckView = UIView()
    private let topView = TopNavigationStackView()
    private let bottomStackView = HomeButtonControlsStackView()
    private let progressHUD: JGProgressHUD = {
        let p = JGProgressHUD(style: .dark)
        p.textLabel.text = "Fetching Users"
        return p
    }()
    
    var lastFetchedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        fetchUsersFromFireStore()
    }
    
    @objc func handleSettings() {
        let vc = RegistrationViewController()
        present(vc, animated: true)
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
        
        // setup buttons
        topView.settingIcon.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFireStore()
    }
    
    fileprivate func fetchUsersFromFireStore() {
        
        progressHUD.show(in: view)
        
        let query = Firestore.firestore().collection("Users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        // pagenation
        
        query.getDocuments { (snapshot, err) in
            self.progressHUD.dismiss()
            if let err = err {
                print("failed to fetch users: ", err.localizedDescription)
                return
            }
            snapshot?.documents.forEach({ (documentSnap) in
                let userDictonary = documentSnap.data()
                let user = User(dictionary: userDictonary)
                self.lastFetchedUser = user
                self.setupCards(user: user)
            })
        }
    }
    
    fileprivate func setupCards(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
}
