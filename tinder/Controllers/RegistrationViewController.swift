//
//  RegistrationViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/20/18.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    fileprivate let registrationVM = RegistrationViewModel()
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let selectProfileImage: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Image", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.heightAnchor.constraint(equalToConstant: 270).isActive = true
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = true
        return btn
    }()
    
    fileprivate let fullNameTextField: RegistrationTextField = {
        let tf = RegistrationTextField(padding: 16)
        tf.backgroundColor = .white
        tf.placeholder = "Enter FullName"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let emailNameTextField: RegistrationTextField = {
        let tf = RegistrationTextField(padding: 16)
        tf.placeholder = "Enter Email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let passwordNameTextField: RegistrationTextField = {
        let tf = RegistrationTextField(padding: 16)
        tf.placeholder = "Enter Password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 25
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [fullNameTextField,
                                                emailNameTextField,
                                                passwordNameTextField,
                                                signUpButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var mainStackView = UIStackView(arrangedSubviews: [selectProfileImage,
                                                   verticalStackView])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        setupLayout()
        setupTapGesture()
        setupNotificationObservers()
        setupRegistrationViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObservers()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.frame
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            mainStackView.axis = .horizontal
        } else {
            mainStackView.axis = .vertical
        }
    }
}

//Mark:- Firebase extension

extension RegistrationViewController {
    
    @objc func handleSignUp() {
        guard let email = emailNameTextField.text, let pwd = passwordNameTextField.text, let fullName = fullNameTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: pwd) { (res, err) in
            if let error = err {
                self.showhud(withError: error)
                return
            }
            print("User registered successfully: ", res?.user.uid)
        }
    }
    
    func showhud(withError err: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text =  err.localizedDescription
        hud.show(in: view)
        hud.dismiss(afterDelay: 2, animated: true)
    }
}

//MARK:- ViewModel extension

extension RegistrationViewController {
    
    func setupRegistrationViewModel() {
        registrationVM.isFormValidObserver = { [unowned self] (isFormValid) in
            self.handleButtonChnageAfterValidity(isFormValid: isFormValid)
        }
    }
    
    @objc func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationVM.fullName = textField.text
        } else if textField == passwordNameTextField {
            registrationVM.password = textField.text
        } else {
            registrationVM.email = textField.text
        }
    }
    
    private func handleButtonChnageAfterValidity(isFormValid: Bool) {
        signUpButton.isEnabled = isFormValid
        signUpButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8128934503, green: 0.1175386086, blue: 0.3345344663, alpha: 1) : .lightGray
    }
}

//MARK:- Keyboard notifications extension

extension RegistrationViewController {
    
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
        let bottomSpace = view.frame.height - mainStackView.frame.origin.y - mainStackView.frame.height
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

//MARK:- UI extension

extension RegistrationViewController {
    
    fileprivate func setupLayout() {
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        view.addSubview(mainStackView)
        mainStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        selectProfileImage.widthAnchor.constraint(equalToConstant: 275).isActive = true
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    fileprivate func addGradient() {
        let topColor = #colorLiteral(red: 0.974457562, green: 0.3630923927, blue: 0.3745511174, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8920144439, green: 0.1395124793, blue: 0.4601837993, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
    }
    
}
