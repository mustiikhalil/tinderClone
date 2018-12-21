//
//  RegistrationViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/20/18.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    fileprivate let selectProfileImage: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Image", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.heightAnchor.constraint(equalToConstant: 270).isActive = true
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    fileprivate let fullNameTextField: RegistrationTextField = {
        let tf = RegistrationTextField(padding: 16)
        tf.backgroundColor = .white
        tf.placeholder = "Enter FullName"
        return tf
    }()
    
    fileprivate let emailNameTextField: RegistrationTextField = {
        let tf = RegistrationTextField(padding: 16)
        tf.placeholder = "Enter Email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    fileprivate let passwordNameTextField: RegistrationTextField = {
        let tf = RegistrationTextField(padding: 16)
        tf.placeholder = "Enter Password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        return tf
    }()
    
    fileprivate let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.8128934503, green: 0.1175386086, blue: 0.3345344663, alpha: 1)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [selectProfileImage,
                                                   fullNameTextField,
                                                   emailNameTextField,
                                                   passwordNameTextField,
                                                   signUpButton])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        setupLayout()
        setupTapGesture()
        setupNotificationObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObservers()
    }
    
    fileprivate func setupLayout() {
        
        stackView.axis = .vertical
        stackView.spacing = 4
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    fileprivate func addGradient() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.974457562, green: 0.3630923927, blue: 0.3745511174, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8920144439, green: 0.1395124793, blue: 0.4601837993, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
    }
}


extension RegistrationViewController {
    
    //MARK:- Keyboard notifications
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = frame.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
}
