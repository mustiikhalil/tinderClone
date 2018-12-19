//
//  User.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/19/18.
//

import UIKit

struct User: ProducesCardViewModel {
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attString = NSMutableAttributedString(string: name, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attString.append(NSAttributedString(string: "  \(age)", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        attString.append(NSAttributedString(string: "\n\(profession)", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .light)]))
        
        return CardViewModel(imageName: imageName, attString: attString, textAlligment: .left)
    }
}
