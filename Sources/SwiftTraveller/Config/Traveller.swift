//Copyright © 2020 Radhachandan Chilamkurthy. All rights reserved.

import UIKit

/**
 !* @discussion: This class controls all the navigation behaviour for the entire Application. It 's been used as Singleton object via shared reference.
 */

public final class Traveller {
    private static var sharedInstance: Traveller?
    private var wayFinding: TravellerWayFindingProtocol?
    var storage: [WayFinding] = [] // To store current stack when config is about to change the router.
    
    public class var shared : Traveller {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = Traveller()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    private init() {
        print("Traveller init")
    }
    
    /**
     !* @discussion: This gonna check weather is there an instantiateInitialViewController from storybard or not, if not then it gonna make a rootview controller as navigation
     !* @param: TravellerStoryBoardProtocol --->  The controller gonna pick from this storybord.
     !* @param: ControllerDestination --->  This will make a viewController based on the value passed.
     !* @param: UIViewController? --->  This will return the rootviewController like UIViewContoller if not nil to throw the error.
     */
    
    private lazy var rootController: (TravellerStoryBoardProtocol, ControllerDestination) -> UIViewController? = { (story, controller) in
        
        if  let rootViewContoller = story.instantiateInitialViewController()  {
            return rootViewContoller
            
        } else {
            if let viewController = UIViewController.makeViewController(
                for: controller,
                   storyBoard: story,
                   modelPresentationStyle: UIModalPresentationStyle.none,
                   modelTransistionStyle: .none
            ) {
                let navigationController = UINavigationController(rootViewController: viewController)
                return navigationController
                
            }
        }
        return nil
    }
    
    /**
     !* @discussion: Configuration part for entire Navigation WayFinding.
     !* @param: TravellerWayFindingProtocol ---> This controls entire WayFinding of the app with the help of WayFinding class which conforms to TravellerWayFindingProtocol & internally this has control over UINavigationController, UIViewController, UIStoryboard, UIStoryboardSegue, UIWindow. Please refere inside logic for more understanding.
     */
    public func config(wayFinding: TravellerWayFindingProtocol?) {
        guard let _wayFinding = wayFinding else { fatalError("Traveller config failed to assign router") }
        self.wayFinding = _wayFinding
    }
    
    /**
     !* @discussion: This will remove Traveller reference from the memory
     */
    public func clear() {
        self.wayFinding = nil
        Traveller.sharedInstance = nil
    }
    
    deinit {
        print("Traveller de-init")
    }
}

extension Traveller {
    
    public enum route: Equatable {
        
        /**
         !* @discussion: All the below cases refers to navigation attributes, let's go one by one.
         !* @param: StoryDestination ---> This refers to StoryBoard file name
         !* @param: ControllerDestination ---> This refers to Controller file name
         !* @param: TravellerWindowProtocol ---> This refers to UIWindow that conforms to custom protocol, this protcol will be helpful to mock the object.
         !* @param: UIModalPresentationStyle ---> ViewController presentation style.
         !* @param: UIModalTransitionStyle ---> ViewController presentation animations.
         !* @param: Bool ---> Manipluates required logic, Please refer to inner logic.
         !* @param: TravellerNavigationProtocol ----> Takes cares of naviagtion
         !* @param: TravellerViewControllerProtocol ----->  Takes cares of viewcontroller
         !* @param: TravellerStoryBoardProtocol  ----->  Takes cares of storyBoard
         !* @return: UIViewController --->  Returns respective UIViewController at required places, once the logic has been rendered.
         */
        
        /**
         !* @discussion:  This function will help to change the window rootViewController.
         */
        case switchRootViewController(
            storyBoard: TravellerStoryBoardProtocol,
            controllerDestination: ControllerDestination,
            hidesTopBar: Bool,
            hidesBottomBar: Bool,
            animated: Bool,
            window: TravellerWindowProtocol?,
            viewAnimation: UIView.AnimationOptions
        )
        
        /**
         !* @discussion:  This function will help to present the ViewController from curren ViewController as a root navigation.
         */
        case present(
            controller: ControllerDestination,
            animated: Bool,
            hidesTopBar: Bool,
            hidesBottomBar: Bool,
            modelTransistion: UIModalTransitionStyle,
            modelPresentation: UIModalPresentationStyle
        )
        
        /**
         !* @discussion:  This function will help to push the ViewController from curren ViewController navigation.
         */
        case push(
            controller: ControllerDestination,
            animated: Bool,
            hidesTopBar: Bool,
            hidesBottomBar: Bool,
            modelTransistion: UIModalTransitionStyle,
            modelPresentation: UIModalPresentationStyle
        )
        
        /**
         !* @discussion:  This function will help to performSegue to respective  ViewController using UIStoryBoardSegue.
         !* @note:  In-Order to use this we need to wire segues in StoryBoard.
         */
        case performSegue(
            segue: ControllerDestination,
            stroyPorotocol: TravellerStoryBoardProtocol,
            modelTransistion: UIModalTransitionStyle,
            animated: Bool,
            hidesTopBar: Bool,
            hidesBottomBar: Bool)
        
        
        
        /**
         !* @discussion:  This function will help to adds the respective controller as a child on current  ViewController and returns back  child ViewController.
         */
        case addChild(childController: ControllerDestination, modelTransistionStyle: UIModalTransitionStyle)
        
        /**
         !* @discussion:  This function will help to remove the child controller on current controller.
         */
        case removeChild
        
        
        /**
         !* @discussion:  This function will help to pop the current controller from navigation stack. We can use pop to root or previous controller based on Bool value.
         */
        case pop(
            toRootController: Bool,
            animated: Bool,
            modelTransistionStyle: UIModalTransitionStyle
        )
        
        
        /**
         !* @discussion:  This function will help to pop the respective view controller from navigation stack, and return back the popped view controller.
         */
        case popToViewController(
            destination: ControllerDestination,
            animated: Bool,
            modelTransistionStyle: UIModalTransitionStyle
        )
        
        
        /**
         !* @discussion:  This function will help to go back  to respective  ViewController using UIStoryBoardSegue with unwind.
         !* @note:  In-Order to use this we need to wire segues in StoryBoard.
         */
        case unwind(
            destination: ControllerDestination,
            modelTransistionStyle: UIModalTransitionStyle,
            storyBoardSegue: TravellerStoryBoardSegueProtocol
        )
        
        /**
         !* @discussion:  This function will help to dismiss the presented ViewController on current ViewController.
         */
        case dismiss(
            modelTransistionStyle: UIModalTransitionStyle,
            animated: Bool,
            dismissed: ((Bool) -> Void)
        )
        
        
        @discardableResult
        public func perform<T>(_ configure: ((T) -> Void)? = nil) -> T? where T: UIViewController {
            switch self {
                case let .switchRootViewController(
                    storyBoard,
                    destination,
                    hidesTopBar,
                    hidesBottomBar,
                    animated,
                    window,
                    viewAnimation
                ):
                    return Traveller.shared.switchRootViewController(
                        destination: destination,
                        storyBoard: storyBoard,
                        hidesTopBar: hidesTopBar,
                        hidesBottomBar: hidesBottomBar,
                        animated: animated,
                        window: window,
                        animations: viewAnimation,
                        configure: configure
                    )
                case let .present(
                    controller,
                    hidesTopBar,
                    hidesBottomBar,
                    animated,
                    modelTransistion,
                    modelPresentation
                ):
                    return Traveller.shared.wayFinding?.present(
                        to: controller,
                        modelPresentationStyle: modelPresentation,
                        modelTransistionStyle: modelTransistion,
                        hidesTopBar: hidesTopBar,
                        hidesBottomBar: hidesBottomBar,
                        animated: animated,
                        configure: configure
                    )
                case let .push(
                    controller,
                    animated,
                    hidesTopBar,
                    hidesBottomBar,
                    modelTransistion,
                    modelPresentation
                ):
                    return Traveller.shared.wayFinding?.push(
                        to: controller,
                        hidesTopBar: hidesTopBar,
                        hidesBottomBar: hidesBottomBar,
                        modelPresentationStyle: modelPresentation,
                        modelTransistionStyle: modelTransistion,
                        animated: animated,
                        configure: configure
                    )
                case let .performSegue(
                    segue,
                    stroyPorotocol,
                    modelTransistion,
                    animated,
                    hidesTopBar,
                    hidesBottomBar
                ):
                    return Traveller.shared.wayFinding?.performSegue(
                        to: segue,
                        storyBoardProtocol: stroyPorotocol,
                        modelTransistionStyle: modelTransistion,
                        hidesTopBar: hidesTopBar,
                        hidesBottomBar: hidesBottomBar,
                        animated: animated,
                        configure: configure
                    )
                case let .addChild(childController, modelTransistionStyle):
                    return Traveller.shared.wayFinding?.addChild(
                        to: childController,
                        modelTransistionStyle: modelTransistionStyle,
                        configure: configure
                    )
                case .removeChild:
                    Traveller.shared.wayFinding?.removeChild()
                case let .pop(
                    toRootController,
                    animated,
                    modelTransistionStyle
                ):
                    Traveller.shared.wayFinding?.pop(
                        toRootController: toRootController,
                        animated: animated,
                        modelTransistionStyle: modelTransistionStyle
                    )
                case let .popToViewController(
                    destination,
                    animated,
                    modelTransistionStyle
                ):
                    return Traveller.shared.wayFinding?.popToViewController(
                        destination: destination,
                        animated: animated,
                        modelTransistionStyle: modelTransistionStyle,
                        configure: configure
                    )
                case let .dismiss(
                    modelTransistionStyle,
                    animated,
                    dismissed
                ):
                    Traveller.shared.wayFinding?.dismiss(
                        modelTransistionStyle: modelTransistionStyle,
                        animated: animated,
                        dismissed: dismissed
                    )
                case let .unwind(
                    destination,
                    modelTransistionStyle,
                    storyBoardSegue
                ):
                    return Traveller.shared.wayFinding?.unwind(
                        to: destination,
                        modelTransistionStyle: modelTransistionStyle,
                        storyBoardSegue: storyBoardSegue,
                        configure: configure
                    )
            }
            return nil
        }
        
        
        public static func == (lhs: route, rhs: route) -> Bool {
            switch (lhs, rhs) {
                case let (.pop(lhstoRoot, lhsanimate, lhsTransistionStyle), .pop(rhstoRoot, rhsanimate, rhsTransistionStyle)):
                    return lhstoRoot == rhstoRoot && rhsanimate == lhsanimate && lhsTransistionStyle == rhsTransistionStyle
                default:
                    break
            }
            return false
        }
    }
}


private extension Traveller {
    /**
     !* @discussion:  This function will help to change the window rootViewController.
     */
    
    func switchRootViewController<T>(
        destination: ControllerDestination,
        storyBoard: TravellerStoryBoardProtocol,
        hidesTopBar: Bool,
        hidesBottomBar: Bool,
        animated: Bool,
        window: TravellerWindowProtocol?,
        animations: UIView.AnimationOptions,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController {
        
        guard let window = window else { fatalError("switchRootViewController window is nil") }
        
        guard let rootViewController = rootController(storyBoard, destination) else {fatalError("Cannot get rootViewController or make rootViewController from storyboard")}
        
        var viewController: UIViewController?
        var wayFinding: WayFinding?
        
        if animated {
            window.animateRootChangeToWindow(options: animations, root: rootViewController)
        }else {
            window.rootViewController = rootViewController
        }
        
        window.makeKeyAndVisible()
        
        if let navigation = window.rootViewController as? UINavigationController, let currentViewController = UIViewController.makeViewController(for: destination, storyBoard: storyBoard, modelPresentationStyle: UIModalPresentationStyle.none, modelTransistionStyle: .crossDissolve){
            
            viewController = currentViewController
            wayFinding = WayFinding(navigation: navigation, viewController: navigation.topViewController, storyBoard: currentViewController.storyboard)
        }
        
        if let tabController = window.rootViewController as? UITabBarController, let navigation = tabController.viewControllers?.first as? UINavigationController, let topViewController = navigation.topViewController {
            
            viewController = topViewController
            wayFinding = WayFinding(navigation: navigation, viewController: viewController, storyBoard: topViewController.storyboard)
        }
        
        viewController?.hidesBottomBarWhenPushed = hidesBottomBar
        viewController?.navigationController?.setNavigationBarHidden(hidesTopBar, animated:false)
        Traveller.shared.config(wayFinding: wayFinding)
        configure?(viewController as! T)
        return viewController as? T
    }
}
