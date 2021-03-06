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
    
    var loginControllerDelegate: LoginControllerDelegate?
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let selectProfileImage: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Image", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handlePickingPhoto), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
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
    
    fileprivate let goToLogin: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Go to Login", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        b.addTarget(self, action: #selector(handleOpenSignIn), for: .touchUpInside)
        return b
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
    
    lazy var selectPhotoButtonHeightAnchor = selectProfileImage.heightAnchor.constraint(equalToConstant: 270)
    
    lazy var selectPhotoButtonWidthAnchor = selectProfileImage.widthAnchor.constraint(equalToConstant: 270)
    
    lazy var mainStackView = UIStackView(arrangedSubviews: [selectProfileImage,
                                                   verticalStackView])
    
    let registerHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        setupLayout()
        setupTapGesture()
        setupRegistrationViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationObservers()
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
            verticalStackView.distribution = .fillEqually
            selectPhotoButtonHeightAnchor.isActive = false
            selectPhotoButtonWidthAnchor.isActive = true
        } else {
            mainStackView.axis = .vertical
            verticalStackView.distribution = .fill
            selectPhotoButtonWidthAnchor.isActive = false
            selectPhotoButtonHeightAnchor.isActive = true
        }
    }
    
}

//MARK:- Firebase extension

extension RegistrationViewController {
    
    @objc func handleSignUp() {
        handleTapDismiss()
        registrationVM.preformRegistration { [unowned self] (err) in
            if let err = err {
                self.showhud(withError: err)
                return
            }
            self.dismiss(animated: true, completion: {
                self.loginControllerDelegate?.didFinishLogin()
            })
        }
    }
    
    func showhud(withError err: Error) {
        registerHUD.dismiss()
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
        registrationVM.isValid.bind { [unowned self] (isValid) in
            guard let isFormValid = isValid else { return }
            self.handleButtonChnageAfterValidity(isFormValid: isFormValid)
        }
        registrationVM.image.bind { [unowned self] (img) in
            self.selectProfileImage.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        registrationVM.isRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registerHUD.textLabel.text = "Registering"
                self.registerHUD.show(in: self.view)
            } else {
                self.registerHUD.dismiss()
            }
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

//MARK:- PhotoPicker Delegate

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handlePickingPhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as? UIImage
        registrationVM.image.value = img
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

//MARK:- UI extension

extension RegistrationViewController {
    
    @objc fileprivate func handleOpenSignIn() {
        let loginVC = LoginController()
        loginVC.loginControllerDelegate = loginControllerDelegate
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    fileprivate func setupLayout() {
        
        navigationController?.isNavigationBarHidden = true
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        view.addSubview(mainStackView)
        
        mainStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(goToLogin)
        goToLogin.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
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
