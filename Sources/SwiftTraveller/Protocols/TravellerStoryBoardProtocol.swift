//Copyright © 2020 Radhachandan Chilamkurthy. All rights reserved.

import UIKit

public protocol TravellerStoryBoardProtocol {
    func instantiateViewController(withIdentifier identifier: String) -> UIViewController
    func instantiateInitialViewController() -> UIViewController?
}

extension UIStoryboard: TravellerStoryBoardProtocol {}

