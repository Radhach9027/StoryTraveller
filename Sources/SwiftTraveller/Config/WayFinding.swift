//Copyright © 2020 Radhachandan Chilamkurthy. All rights reserved.

import UIKit

public final class WayFinding: NSObject, UIAdaptivePresentationControllerDelegate {
    
    private var navigation: TravellerNavigationProtocol?
    private var viewController : TravellerViewControllerProtocol?
    private var storyBoard: TravellerStoryBoardProtocol?
    
    public init(
        navigation: TravellerNavigationProtocol?,
        viewController : TravellerViewControllerProtocol?,
        storyBoard: TravellerStoryBoardProtocol?
    ) {
        self.navigation = navigation
        self.storyBoard = storyBoard
        self.viewController = viewController
        print("WayFinding init")
    }
    
    deinit {
        print("WayFinding deinit")
    }
}

extension WayFinding: TravellerWayFindingProtocol {
    
    /**
     !* @discussion: This function takes cares of pushing viewcontroller over navigation controller.
     !* @param: ControllerDestination, storyDestination , modelPresentationStyle, modelTransistionStyle
     1. We are trying to prepare a view controller with the help of ControllerDestination & storyDestination and then adding presenting style, transistion style by using modelPresentationStyle & modelTransistionStyle to self.viewController?.makeViewController via TravellerViewControllerProtocol.
     2. Then assigning the current root navigation,viewcontroller, storyboard  to main navigation,viewcontroller, storyboard in order to maintain the stack. (This will help us to push on presented view controller)
     3. Then we are fetching navigation via TravellerNavigationProtocol and finally pushing & returning the controller.
     */
    
    public func push<T>(
        to destination: ControllerDestination,
        hidesTopBar: Bool,
        hidesBottomBar: Bool,
        modelPresentationStyle: UIModalPresentationStyle,
        modelTransistionStyle: UIModalTransitionStyle,
        animated: Bool,
        configure: ((T) -> Void)?
    ) -> T? where T: UIViewController {
        if let viewController = UIViewController.makeViewController(
            for: destination,
               storyBoard: self.storyBoard,
               modelPresentationStyle: modelPresentationStyle,
               modelTransistionStyle: modelTransistionStyle) as? T,
           let navigation = self.navigation {
            configure?(viewController)
            self.navigation?.setNavigationBarHidden(hidesTopBar, animated: false)
            self.viewController?.hidesBottomBarWhenPushed = hidesBottomBar
            viewController.endEditing()
            navigation.pushViewController(viewController, animated: animated)
            return viewController
        }
        return nil
    }
    
    /**
     !* @discussion: This function takes cares of presenting viewcontroller on navigation controller as a root navigation.
     !* @param: ControllerDestination, storyDestination , modelPresentationStyle, modelTransistionStyle
     1. We are trying to prepare a view controller with the help of ControllerDestination & storyDestination and then adding presenting style, transistion style by using modelPresentationStyle & modelTransistionStyle to self.viewController?.makeViewController via TravellerViewControllerProtocol.
     2. Then we are fetching root navigation by self.navigation?.makeRootNavigation via TravellerNavigationProtocol and passing current controller as root to it.
     3. Then assigning the current root navigation,viewcontroller, storyboard  to main navigation,viewcontroller, storyboard in order to maintain the stack. (This will help us to push on presented view controller)
     4. Finally we are presenting the controller & returning it.
     */
    
    public func present<T>(
        to destination: ControllerDestination,
        modelPresentationStyle: UIModalPresentationStyle,
        modelTransistionStyle: UIModalTransitionStyle,
        hidesTopBar: Bool,
        hidesBottomBar: Bool,
        animated: Bool,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController {
        if let viewController = UIViewController.makeViewController(
            for: destination,
               storyBoard: self.storyBoard,
               modelPresentationStyle: modelPresentationStyle,
               modelTransistionStyle: modelTransistionStyle) as? T,
           let topViewController = self.viewController {
            configure?(viewController)
            self.stackStorage()
            let navigation = UINavigationController(rootViewController: viewController)
            let wayFinding = WayFinding(
                navigation: navigation,
                viewController: viewController,
                storyBoard: viewController.storyboard
            )
            Traveller.shared.config(wayFinding: wayFinding)
            viewController.endEditing()
            viewController.navigationController?.setNavigationBarHidden(hidesTopBar, animated: false)
            topViewController.present(
                navigation,
                animated: animated,
                completion: nil
            )
            viewController.navigationController?.presentationController?.delegate = self
            return viewController
        }
        return nil
    }
    
    
    /**
     !* @discussion: This function takes cares of WayFindingConfi when ever it's required.
     !* @param: navigation, viewController , storyBoard
     1. When ever if there is a change in the navigation stack, we have to use this function. In-order to main the stack.
     
     Note: If you'r using tabbar controller in your application, call this function in you'r TabBarController delegate method didSelect. In-order to manage navigation stack in tabbar controller.
     */
    
    public func performSegue<T>(
        to destination: ControllerDestination,
        storyBoardProtocol: TravellerStoryBoardProtocol,
        modelTransistionStyle: UIModalTransitionStyle,
        hidesTopBar: Bool,
        hidesBottomBar: Bool,
        animated: Bool,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController {
        if let viewController = UIViewController.makeViewController(
            for: destination,
               storyBoard: storyBoardProtocol,
               modelPresentationStyle: nil,
               modelTransistionStyle: modelTransistionStyle
        ) as? T, let topViewController: TravellerViewControllerProtocol = self.viewController {
            configure?(viewController)
            viewController.endEditing()
            switch destination {
                case let .type(val):
                    topViewController.performSegue(withIdentifier: val, sender: viewController)
            }
            return viewController
        }
        return nil
    }
    
    
    /**
     !* @discussion: This function takes cares of adding child viewcontroller on current controller.
     !* @param: ControllerDestination, storyDestination , modelTransistionStyle
     1. We are trying to prepare a view controller with the help of ControllerDestination & storyDestination and then adding transistion style by using modelTransistionStyle to self.viewController?.makeViewController via TravellerViewControllerProtocol.
     2. Then we are fetching current controller which is visible on the screen by using self.viewController via TravellerViewControllerProtocol.
     3. Then assigning the current root navigation,viewcontroller, storyboard  to main navigation,viewcontroller, storyboard in order to maintain the stack. (This will help us to push on presented view controller)
     4. Finally we are adding the controller as child & returning it.
     Note: If you dont want present something from child, then avoid point 3. That will remain same.
     */
    
    public func addChild<T>(
        to childController: ControllerDestination,
        modelTransistionStyle: UIModalTransitionStyle,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController {
        if let viewController = UIViewController.makeViewController(
            for: childController,
               storyBoard: self.storyBoard,
               modelPresentationStyle: nil,
               modelTransistionStyle: modelTransistionStyle
        ) as? T, let topController = self.viewController {
            configure?(viewController)
            let wayFinding = WayFinding(
                navigation: self.navigation,
                viewController: viewController,
                storyBoard: self.storyBoard
            )
            Traveller.shared.config(wayFinding: wayFinding)
            topController.add(viewController)
            return viewController
        }
        return nil
    }
    
    
    /**
     !* @discussion: This function takes cares of WayFindingConfi when ever it's required.
     !* @param: navigation, viewController , storyBoard
     1. When ever if there is a change in the navigation stack, we have to use this function. In-order to main the stack.
     
     Note: If you'r using tabbar controller in your application, call this function in you'r TabBarController delegate method didSelect. In-order to manage navigation stack in tabbar controller.
     */
    
    public func unwind<T>(
        to destination: ControllerDestination,
        modelTransistionStyle: UIModalTransitionStyle,
        storyBoardSegue: TravellerStoryBoardSegueProtocol,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController {
        if let topViewController = self.viewController as? T , let destinationVc = UIViewController.makeViewController(
            for: destination,
               storyBoard: self.storyBoard,
               modelPresentationStyle: nil,
               modelTransistionStyle: modelTransistionStyle
        ) as? T{
            configure?(topViewController)
            topViewController.endEditing()
            topViewController.unwind(for: UIStoryboardSegue(
                identifier: storyBoardSegue.identifier,
                source: storyBoardSegue.source,
                destination: storyBoardSegue.destination
            ), towards: destinationVc)
            return topViewController
        }
        return nil
    }
    
    
    /**
     !* @discussion: This function takes cares of removing child controller on top controller.
     */
    
    public func removeChild() {
        if let childViewController = self.viewController {
            childViewController.remove()
        }
    }
    
    
    /**
     !* @discussion: This function takes cares of popping controller to root or previous.
     !* @param: toRootController, animated, modelTransistionStyle
     1. Based on the flags toRootController, animated, modelTransistionStyle it gonna act accordinly to navigation.
     */
    
    public func pop(
        toRootController: Bool,
        animated: Bool,
        modelTransistionStyle: UIModalTransitionStyle
    ) {
        if let navigationController = self.navigation {
            if toRootController {
                if (self.viewController?.presentedViewController != nil) {
                    dismiss(modelTransistionStyle: modelTransistionStyle, animated: animated) { _ in }
                } else {
                    navigationController.popToRootViewController(animated: animated)
                }
            } else {
                navigationController.popViewController(animated: animated)
            }
        }
    }
    
    
    /**
     !* @discussion: This function takes cares of popping to respective viewcontroller with-in navigation stack.
     !* @param: destination, animated, modelTransistionStyle
     1. A destination view controller should be passed and can apply modelTransistionStyle & animated flags to it.
     2. This will check the child controllers of navigation and if destination exists in that, then this will pop to destination,
     */
    
    public func popToViewController<T>(
        destination: ControllerDestination,
        animated: Bool,
        modelTransistionStyle: UIModalTransitionStyle,
        configure: ((T) -> Void)?) -> T? where T : UIViewController {

        if let navigationController = self.navigation {
            
            for controller in navigationController.viewControllers {
                
                switch destination {
                    case let .type(val):
                        if controller.className == val {
                            if let controller = controller as? T {
                                configure?(controller)
                                controller.endEditing()
                                navigationController.popToViewController(controller, animated: animated)
                                return controller
                            }
                        }
                        break
                }
            }
        }
        return nil
    }
    
    /**
     !* @discussion: This function takes cares of dismissing the presented controller on stack.
     !* @param: modelTransistionStyle, animated
     1. Apply modelTransistionStyle and animated flag accordingly.
     */
    
    public func dismiss(modelTransistionStyle: UIModalTransitionStyle, animated: Bool, dismissed: @escaping ((Bool) -> Void)) {
        if let topViewController = self.viewController{
            topViewController.modalTransitionStyle = modelTransistionStyle
            topViewController.dismiss(animated: animated) { [weak self] in
                dismissed(true)
                self?.checkStorageAndReAssignWayFindingWhenControllerIsDismissed()
            }
        }
    }
    
}

extension WayFinding {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.checkStorageAndReAssignWayFindingWhenControllerIsDismissed()
    }
}

private extension WayFinding {
    func stackStorage() {
        Traveller.shared.storage.removeAll()
        Traveller.shared.storage.append(self)
    }
    
    func checkStorageAndReAssignWayFindingWhenControllerIsDismissed() {
        if let stackWayfinding = Traveller.shared.storage.first {
            Traveller.shared.config(wayFinding: stackWayfinding)
        }
    }
}


