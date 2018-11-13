//
//  AppConstants.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import Foundation
import UIKit

enum ScreenTitle: String {
    case home = "Home"
}

struct AppConstants {
    static let protocolo    : String = "http://"
    static let domain       : String = "demo.com/list"
}

public struct Storyboard {
    static let kMainStoryboard              = UIStoryboard(name: "Main",     bundle: nil)
}
public struct AssetsImages {
    
    static let kloading                         = UIImage(named: "loading")
}
