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

class CardViewModel {
    
    fileprivate var imageIndex = 0 {
        didSet {
            imageIndexObserver?(imageNames[imageIndex], imageIndex)
        }
    }
    
    let imageNames: [String]
    let attString: NSMutableAttributedString
    let textAlligment: NSTextAlignment
    
    //Reactive programming
    
    var imageIndexObserver: ((String?, Int) -> ())?
    
    init(imageNames images: [String], attString text: NSMutableAttributedString, textAlligment alligment: NSTextAlignment) {
        imageNames = images
        attString = text
        textAlligment = alligment
    }
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
