//Copyright © 2020 Radhachandan Chilamkurthy. All rights reserved.

import UIKit

// Mark: WayFinding Attributes
public protocol TravellerWayFindingProtocol {
    func push<T>(
        to destination: ControllerDestination,
        hidesTopBar: Bool,
        hidesBottomBar: Bool,
        modelPresentationStyle: UIModalPresentationStyle,
        modelTransistionStyle: UIModalTransitionStyle,
        animated: Bool,
        configure: ((T) -> Void)?
    ) -> T? where T: UIViewController
    
    func present<T>(
        to destination: ControllerDestination,
        modelPresentationStyle: UIModalPresentationStyle,
        modelTransistionStyle: UIModalTransitionStyle,
        hidesTopBar: Bool,
        hidesBottomBar: Bool,
        animated: Bool,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController
    
    func performSegue<T>(
        to destination: ControllerDestination,
        storyBoardProtocol: TravellerStoryBoardProtocol,
        modelTransistionStyle: UIModalTransitionStyle,
        hidesTopBar: Bool,
        hidesBottomBar: Bool,
        animated: Bool,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController
    
    func addChild<T>(
        to childController: ControllerDestination,
        modelTransistionStyle: UIModalTransitionStyle,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController
    
    func unwind<T>(
        to destination: ControllerDestination,
        modelTransistionStyle: UIModalTransitionStyle,
        storyBoardSegue: TravellerStoryBoardSegueProtocol,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController
    
    func removeChild()
    
    func pop(
        toRootController: Bool,
        animated: Bool,
        modelTransistionStyle: UIModalTransitionStyle
    )
    
    func popToViewController<T>(
        destination: ControllerDestination,
        animated: Bool,
        modelTransistionStyle: UIModalTransitionStyle,
        configure: ((T) -> Void)?
    ) -> T? where T : UIViewController
    
    func dismiss(
        modelTransistionStyle: UIModalTransitionStyle,
        animated: Bool,
        dismissed: @escaping ((Bool) -> Void)
    )
}
