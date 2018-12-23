//
//  RegistrationViewModel.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/23/18.
//

import UIKit

class RegistrationViewModel {
    
    var fullName: String? { didSet { formValidity()} }
    
    var email: String? { didSet { formValidity()} }
    
    var password: String? { didSet { formValidity()} }
    var isFormValidObserver: ((Bool)->())?
    
    private func formValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && password?.count ?? 0 >= 4
        isFormValidObserver?(isFormValid)
    }
}
