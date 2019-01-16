//
//  SettingsViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/30/18.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}
class CustomImagePicker: UIImagePickerController {
    var imageButton: UIButton?
}


class SettingsViewController: UITableViewController {
    
    var user: User?
    var delegate: SettingsControllerDelegate?
    
    private lazy var imageButton1 = createButton(selector: #selector(handleSelectPhoto))
    private lazy var imageButton2 = createButton(selector: #selector(handleSelectPhoto))
    private lazy var imageButton3 = createButton(selector: #selector(handleSelectPhoto))
    
    private lazy var header: UIView = {
        let v = UIView()
        v.addSubview(imageButton1)
        let padding: CGFloat = 16
        imageButton1.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: v.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        imageButton1.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageButton2, imageButton3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        v.addSubview(stackView)
        stackView.anchor(top: v.topAnchor, leading: imageButton1.trailingAnchor, bottom: v.bottomAnchor, trailing: v.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
        setupOberver()
    }
    
    private let ageRange = AgeRangeVM()
    
    func setupOberver(){
        ageRange.bindableAge.bind { [unowned self] (args) in
            let index = IndexPath(item: 0, section: 5)
            let cell = self.tableView.cellForRow(at: index) as! AgeRangeCell
            guard let age = args else { return }
            cell.setupUI(min: age.min, max: age.max)
        }
    }
    
    
    fileprivate func fetchCurrentUser() {
        NetworkManager.shared.fetchCurrentUser { (user) in
            if let u = user {
                self.user = u
                self.loadUserPhotos()
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func loadUserPhotos() {
        guard let photos = user?.imageNames else { return }
        var buttonArray = [imageButton1, imageButton2, imageButton3]
        
        for i in 0..<photos.count {
            if i >= buttonArray.count {
                break
            }
            guard let url = URL(string: photos[i]) else { return }
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                buttonArray[i].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePicker()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let button = (picker as? CustomImagePicker)?.imageButton
        button?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadedData = selectedImage?.jpegData(compressionQuality: 0.7) else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image"
        hud.show(in: view)
        ref.putData(uploadedData, metadata: nil) { (metadata, error) in
            hud.dismiss(animated: true)
            if let err = error {
                print("settingsVC - error uploading image: ", err.localizedDescription)
                return
            }
            print("finished uploading image")
            ref.downloadURL(completion: { (url, error) in
                if let err = error {
                    print("settingVC - error getting url: ", err.localizedDescription)
                    return
                }
                if let stringUrl = url?.absoluteString {
                    self.user?.imageNames.append(stringUrl)
                }
            })
        }
    }
    
}

// MARK:- Table view functions

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLable = HeaderLabel()
        headerLable.font = UIFont.boldSystemFont(ofSize: 16)
        switch section {
        case 1:
            headerLable.text = "Username"
        case 2:
            headerLable.text = "Profession"
        case 3:
            headerLable.text = "Age"
        case 4:
            headerLable.text = "Bio"
        default:
            headerLable.text = "Age Range"
        }
        return headerLable
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let rangeCell = AgeRangeCell(user: user)
            rangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            rangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            return rangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Username"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
        default:
            cell.textField.placeholder = "Enter Bio"
            cell.textField.text = user?.bio
            cell.textField.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        }
        return cell
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text ?? ""
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text ?? ""
    }
    
    @objc fileprivate func handleBioChange(textField: UITextField) {
        self.user?.bio = textField.text ?? ""
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        ageRange.minAge = Int(slider.value)
        user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        ageRange.maxAge = Int(slider.value)
        user?.maxSeekingAge = Int(slider.value)
    }
    
}

// MARK:- Navigation Buttons

extension SettingsViewController {
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "uid": uid,
            "fullname": user?.name ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "images": user?.imageNames,
            "bio": user?.bio,
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1,
            ]
        
        Firestore.firestore().collection("Users").document(uid).setData(data) { (error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didSaveSettings()
            })
        }
    }

}

// MARK:- UI

extension SettingsViewController {
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogout)),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        ]
    }
    
    
    func createButton(selector: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle("Select Photo", for: .normal)
        b.backgroundColor = .white
        b.addTarget(self, action: selector, for: .touchUpInside)
        b.imageView?.contentMode = .scaleAspectFill
        b.layer.cornerRadius = 8
        b.clipsToBounds = true
        return b
    }
    
}

fileprivate class HeaderLabel: UILabel {
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
