//
//  SettingsViewController.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/30/18.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
    }
}

// MARK:- Table view functions

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .blue
        return v
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
    
}
