//
//  Advertiser.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/19/18.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterImageName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attText = NSMutableAttributedString(string: title, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attText.append(NSAttributedString(string: "\n\(brandName)", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        return CardViewModel(imageNames: [posterImageName], attString: attText, textAlligment: .center)
    }
}
