//
//  DashBoardViewModel.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/09/28.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import RealmSwift

struct DashboardViewModel {
    
    var links: [Link] {
        get{
            let realm = try! Realm()
            let links = realm.objects(Link.self)
            
            var linkArray = [Link]()
            
            for link in links {
                linkArray.append(link)
            }
            return linkArray
        }
    }
    
    func link(for primaryKey:String) -> Link? {
        let realm = try! Realm()
        let link = realm.object(ofType: Link.self, forPrimaryKey: primaryKey)
        
        return link
    }
    
    func hasLinks(in primaryKey:String) -> Bool {
        let link = self.link(for: primaryKey)
        
        if let link = link {
            if link.myLink.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    func amountOfLinks(in primaryKey:String) -> Int {
        let link = self.link(for: primaryKey)
        
        if let link = link {
            if link.myLink.count > 0 {
                return link.myLink.count
            }
        }
        
        return 0
    }
    
    var allPrimaryKey: [String] {
        get{
            var primaryKeys = [String]()
            for link in links{
                primaryKeys.append(link.site)
            }
            return primaryKeys
        }
    }
}
