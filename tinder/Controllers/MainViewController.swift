//
//  ViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/18/18.
//

import UIKit
import Firebase
import JGProgressHUD

class MainViewController: UIViewController, LoginControllerDelegate {

    var user: User?
    var lastFetchedUser: User?
    
    private let cardDeckView = UIView()
    private let topView = TopNavigationStackView()
    private let bottomStackView = HomeButtonControlsStackView()
    private let progressHUD: JGProgressHUD = {
        let p = JGProgressHUD(style: .dark)
        p.textLabel.text = "Fetching Users"
        return p
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let lVC = RegistrationViewController()
            lVC.loginControllerDelegate = self
            let registrationVC = UINavigationController(rootViewController: lVC)
            present(registrationVC, animated: true)
        }
    }
    
    func didFinishLogin() {
        lastFetchedUser = nil
        fetchCurrentUser()
    }
    
}

// MARK:- Firebase

extension MainViewController: SettingsControllerDelegate {
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    fileprivate func fetchCurrentUser() {
        NetworkManager.shared.fetchCurrentUser { (user) in
            if let u = user {
                self.user = u
                self.fetchUsersFromFireStore()
            }
        }
    }
    
    fileprivate func fetchUsersFromFireStore() {
        
        progressHUD.show(in: view)
//        let minAge = user?.minSeekingAge ?? 0
//        let maxAge = user?.maxSeekingAge ?? 100
        
        let query = Firestore.firestore().collection("Users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 3)
        // whereField("age", isLessThanOrEqualTo: maxAge).whereField("age", isGreaterThanOrEqualTo: minAge) filtering
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
                if user.uid != Auth.auth().currentUser?.uid {
                    self.lastFetchedUser = user
                    self.setupCards(user: user)
                }
            })
        }
    }
    
}

// MARK:- Controls extension

extension MainViewController {
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFireStore()
    }
    
    @objc func handleSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        let vc = UINavigationController(rootViewController: settingsVC)
        present(vc, animated: true)
    }
    
}

// MARK:- UI

extension MainViewController {

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
    
    fileprivate func setupCards(user: User) {
        let cardView = CardView(delegate: self)
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
}

extension MainViewController: CardViewProtocol {
    
    func shouldPresentDetailsFor() {
        let userDetailsController = UserDetailsController()
        present(userDetailsController, animated: true)
    }
    
}
