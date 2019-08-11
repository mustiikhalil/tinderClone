//
//  NetworkManager.swift
//  tinder
//
//  Created by Mustafa Khalil on 1/16/19.
//

import Foundation
import Firebase

class NetworkManager {
    
    static var shared = NetworkManager()
    
    func fetchCurrentUser(completion: @escaping (User?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil)
                return
            }
            guard let dictonary = snapshot?.data() else {
                completion(nil)
                return
            }
            let user = User(dictionary: dictonary)
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
}
