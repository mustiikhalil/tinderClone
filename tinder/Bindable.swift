//
//  Bindable.swift
//  tinder
//
//  Created by Mustafa Khalil on 12/23/18.
//

import Foundation

class Bindable<T> {
    
    fileprivate var observer: ((T?) -> ())?
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
