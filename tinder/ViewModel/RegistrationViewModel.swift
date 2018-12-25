//
//  RegistrationViewModel.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/23/18.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var isRegistering = Bindable<Bool>()
    var image = Bindable<UIImage>()
    var isValid = Bindable<Bool>()
    
    var fullName: String? { didSet { formValidity()} }
    var email: String? { didSet { formValidity()} }
    var password: String? { didSet { formValidity()} }
    
    func preformRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let pwd = password else { return }
        isRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: pwd) { (res, err) in
            if let error = err {
                completion(error)
                return
            }
            self.uploadImageToFirebase(completion: completion)
        }
    }
    
    private func uploadImageToFirebase(completion: @escaping (Error?) -> ()) {
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imgData = image.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imgData, metadata: nil, completion: { (storage, err) in
            if let error = err {
                completion(error)
                return
            }
            ref.downloadURL(completion: { (url, err) in
                if let error = err {
                    completion(error)
                }
                self.saveUserInfoToFireStore(imgUrl: url?.absoluteString ?? "", completion: completion)
                
            })
        })
    }
    
    private func saveUserInfoToFireStore(imgUrl: String, completion: @escaping (Error?) -> ()) {
        let userUID = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullname": fullName ?? "", "uid": userUID, "images": [imgUrl]] as [String : Any]
        Firestore.firestore().collection("Users").document(userUID).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            self.isRegistering.value = false
            completion(nil)
        }
    }
    
    private func formValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && password?.count ?? 0 >= 4
        isValid.value = isFormValid
    }
    
}
