//
//  SwipeImagePageController.swift
//  tinder
//
//  Created by Mustafa Khalil on 8/11/19.
//

import UIKit

class SwipeImagePageController: UIPageViewController {
    
    class ImagesController: UIViewController {
        
        let profileImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            return iv
        }()
        
        var url: URL?
        
        init(str: String) {
            url = URL(string: str)
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            profileImageView.sd_setImage(with: url)
            view.addSubview(profileImageView)
            profileImageView.fillSuperview()
        }
    }
    
    
    fileprivate var controllers: [UIViewController] = []
    
    var images: [String] = [] {
        didSet {
            images.forEach { (str) in
                self.controllers.append(ImagesController(str: str))
            }
            
            guard let first = controllers.first else { return }
            // never forget to do this!
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // data source is required
        dataSource = self
    }
}

extension SwipeImagePageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: { $0 == viewController}) ?? 0
        guard index != 0 else { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: { $0 == viewController}) ?? 0
        guard index != (controllers.count - 1) else { return nil }
        return controllers[index + 1]
    }
    
    
}
