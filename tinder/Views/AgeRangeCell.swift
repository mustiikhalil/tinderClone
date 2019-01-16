//
//  AgeRangeCell.swift
//  tinder
//
//  Created by Mustafa Khalil on 1/10/19.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let s = UISlider()
        s.minimumValue = 18
        s.maximumValue = 50
        return s
    }()
    
    let maxSlider: UISlider = {
        let s = UISlider()
        s.minimumValue = 18
        s.maximumValue = 50
        return s
    }()
    
    let minLabel: AgeRangeLabel = {
        let l = AgeRangeLabel()
        l.text = "Min: 88"
        return l
    }()
    
    let maxLabel: AgeRangeLabel = {
        let l = AgeRangeLabel()
        l.text = "Max: 88"
        return l
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    init(user: User?) {
        super.init(style: .default, reuseIdentifier: nil)
        let min = user?.minSeekingAge ?? 18
        let max = user?.maxSeekingAge ?? 24
        setupUI(min: min, max: max)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider]),
            ])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    func setupUI(min: Int, max: Int) {
        minLabel.text = "Min: \(min)"
        maxLabel.text = "Max: \(max)"
        minSlider.value = Float(min)
        maxSlider.value = Float(max)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AgeRangeVM {
    
    var bindableAge = Bindable<Age>()
    var age = Age(max: 50, min: 18)
    
    var minAge: Int {
        get { return age.min}
        set {
            if newValue > maxAge { maxAge = newValue + 1 }
            age = Age(max: age.max, min: max(18, newValue))
            bindableAge.value = age
        }
    }
    var maxAge: Int {
        get { return age.max}
        set {
            if newValue < minAge { minAge = newValue - 1 }
            age = Age(max: min(50, newValue), min: age.min)
            bindableAge.value = age
        }
    }
    
    struct Age {
        let max: Int
        let min: Int
    }
    
}
