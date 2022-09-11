//Copyright © 2020 Radhachandan Chilamkurthy. All rights reserved.

import UIKit

public protocol TravellerWindowProtocol: class {
    var rootViewController: UIViewController? {get set}
    func makeKeyAndVisible()
    func animateRootChangeToWindow(options: UIView.AnimationOptions, root: UIViewController)
}

extension UIWindow: TravellerWindowProtocol {
    
    public func animateRootChangeToWindow(options: UIView.AnimationOptions, root: UIViewController) {
        
        UIView.transition(
            with: self as UIView,
            duration: 0.5,
            options: options,
            animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.rootViewController = root
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil
        )
    }
}
