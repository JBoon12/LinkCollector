//
//  Utils.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/12/19.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import UIKit

struct Utils {
    static func topViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}
