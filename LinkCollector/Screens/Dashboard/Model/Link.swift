//
//  Link.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/26.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Link: Object {
    
    @objc dynamic var site = ""
    @objc dynamic var linkType = ""
    let myLink = List<String>()
    
    override static func primaryKey() -> String {
        return "site"
    }
}


class MyLinkArray: Object {
    @objc dynamic var link = ""
}
