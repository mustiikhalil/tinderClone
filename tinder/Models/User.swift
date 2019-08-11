//
//  User.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/19/18.
//

import UIKit

struct User: ProducesCardViewModel {
    
    var name: String
    var age: Int?
    var profession: String?
    var bio: String
    var imageNames: [String]
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    let uid: String
    
    init(dictionary: [String: Any]) {
        name = dictionary["fullname"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
        age = dictionary["age"] as? Int
        profession = dictionary["profession"] as? String
        imageNames = dictionary["images"] as? [String] ?? []
        bio = dictionary["bio"] as? String ?? ""
        minSeekingAge = dictionary["minSeekingAge"] as? Int
        maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let ageString = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? "\(profession!)" : "Not Available"
        
        let attString = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attString.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        attString.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .light)]))
        
        return CardViewModel(imageNames: imageNames, attString: attString, textAlligment: .left)
    }
}
