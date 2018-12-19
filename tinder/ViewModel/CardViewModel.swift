//
//  CardViewModel.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/19/18.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    let imageName: String
    let attString: NSMutableAttributedString
    let textAlligment: NSTextAlignment
}
