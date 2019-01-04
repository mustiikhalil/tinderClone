//
//  SettingsViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/30/18.
//

import UIKit

class CustomImagePicker: UIImagePickerController {
    
    var imageButton: UIButton?
}


class SettingsViewController: UITableViewController {
    
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
        headerLable.text = getSectionText(section: section)
        return headerLable
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        cell.textField.placeholder = getPlaceHolderText(section: indexPath.section)
        return cell
    }
    
}

// MARK:- Navigation Buttons

extension SettingsViewController {
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
}

// MARK:- UI

extension SettingsViewController {
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
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
    
    fileprivate func getSectionText(section: Int) -> String {
        switch section {
        case 1:
            return "Name"
        case 2:
            return "Profession"
        case 3:
            return "Age"
        default:
            return "Bio"
        }
    }
    
    fileprivate func getPlaceHolderText(section: Int) -> String {
       return "Enter " + getSectionText(section: section)
    }
    
}

fileprivate class HeaderLabel: UILabel {
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
