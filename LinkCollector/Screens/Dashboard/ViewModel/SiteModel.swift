//
//  SiteModel.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/25.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

struct SiteModel {
    
    let siteList:[String]
    
    init(){
        self.siteList = SiteRepository.getSiteList()
    }
    
    func generateKey(key:String) -> String{
        switch key {
        case "쿠팡":
            return "coupang"
        case "네이버스토어":
            return "smartstore"
        case "유튜브":
            return "youtube"
        case "네이버":
            return "naver"
        default:
            return "others"
        }
    }
    
    func siteDistribution(url:URL){
        let urlString = url.absoluteString
        let position = self.getLinkPosition(url: url)

        let realm = try! Realm()
        var link = realm.object(ofType: Link.self, forPrimaryKey: position)
        
        try! realm.write{
            if let link = link{
                if link.myLink.contains(urlString){
                    return
                }
                link.linkType = "https://"
                link.myLink.append(urlString)
            }else{
                link = Link()
                link!.linkType = "https://"
                link!.site = position
                link!.myLink.append(urlString)
                realm.add(link!, update: .modified)
            }
        }
    }
    
    func siteDistribution(url:URL, position: String){
        let urlString = url.absoluteString

        let realm = try! Realm()
        var link = realm.object(ofType: Link.self, forPrimaryKey: position)
        
        try! realm.write{
            if let link = link{
                if link.myLink.contains(urlString){
                    return
                }
                link.linkType = "https://"
                link.myLink.append(urlString)
            }else{
                link = Link()
                link!.linkType = "https://"
                link!.site = position
                link!.myLink.append(urlString)
                realm.add(link!, update: .modified)
            }
        }
    }
    
    private func getLinkPosition(url: URL) -> String{
        let urlString = url.absoluteString
        let position:String
        if urlString.contains("coupang") {
            position = "coupang"
        }else if urlString.contains("smartstore") {
            position = "smartstore"
        }else if urlString.contains("youtube") {
            position = "youtube"
        }else if urlString.contains("naver") {
            position = "naver"
        }else{
            position = "others"
        }
        return position
    }
    
    func getAmountOfSiteList(str:String) -> Int{
        let key = self.generateKey(key: str)
        let realm = try! Realm()
        let link = realm.object(ofType: Link.self, forPrimaryKey: key)
        
        if let link = link {
            if link.myLink.count > 0{
                return 1
            }
        }
        return 0;
    }
    
    func getAmountOfSite(str:String) -> Int{
        let key = self.generateKey(key: str)
        let realm = try! Realm()
        let link = realm.object(ofType: Link.self, forPrimaryKey: key)
        
        return link?.myLink.count ?? 0
    }
    
    
    func generateURL(url: URL, completionHandler: @escaping (URL) -> Void){
        var linkStr = url.absoluteString
        
        if !linkStr.hasPrefix("http://") && !linkStr.hasPrefix("https://"){
            linkStr = "http://\(linkStr)"
        }
        if let tempURL = URL(string: linkStr){
            AF.request(tempURL).response{response in
                if(response.description.contains("success")){
                    completionHandler(tempURL)
                }
            }
        }
    }
}
