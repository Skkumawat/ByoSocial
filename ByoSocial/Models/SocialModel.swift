//
//  OrderModel.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import UIKit

class SocialModel: NSObject {
    var id: Int = 0
    var linkurl: String = ""
    var mediatype: Int = 1
    
    // MARK: - Intializer
    override init() {
    }
    
    convenience init(_ attributes: [AnyHashable: Any]) {
        self.init()
        id                 = attributes["id"] as? Int ?? 0
        linkurl              = attributes["linkurl"] as? String ?? ""
        mediatype          = attributes["mediatype"] as? Int ?? 1
    }
}
