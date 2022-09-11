import UIKit

extension UIViewController {
    
    public func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    public func remove() {
        guard parent != nil else {return}
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public static func makeViewController<T>(
        for controller: ControllerDestination,
        storyBoard: TravellerStoryBoardProtocol?,
        modelPresentationStyle: UIModalPresentationStyle? = nil,
        modelTransistionStyle: UIModalTransitionStyle? = nil
    ) -> T? where T: UIViewController {
        
        switch controller {
            case let .type(val):
                if let viewController = storyBoard?.instantiateViewController(withIdentifier: val) {
                    if let presentation = modelPresentationStyle {
                        viewController.modalPresentationStyle = presentation
                    }
                    if let transistion = modelTransistionStyle {
                        viewController.modalTransitionStyle = transistion
                    }
                    return viewController as? T
                }
        }
        
        return nil
    }
    
    @discardableResult
    func addConstraints(someController: UIViewController?) -> Bool {
        guard let controller = someController else {return false}
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return true
    }
    
    
    func endEditing() {
        self.view.endEditing(true)
    }
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}

protocol TextFieldViewTouchabilityDelegates: class {
    func rightViewTapped()
}

protocol KeyBoardListenerDelegates: class {
    func keyBoardShow(_ notification: Notification)
    func keyBoardHide(_ notification: Notification)
}

