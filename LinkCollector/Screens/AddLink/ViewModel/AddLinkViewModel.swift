//
//  AddLinkViewModel.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/09/28.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct AddLinkViewModel {
    
    var inputLink = BehaviorSubject<String>(value: "")
    var isNeedLoading = BehaviorSubject<Bool>(value: false)
    var link = BehaviorSubject<LinkModel?>(value: nil)
    
    lazy var isSaveEnabled = {
        return inputLink.compactMap{ (value: String) -> Bool? in
            if value.count <= 0 {
                return false
            }
            
            return true
        }
    }()
    
    func isValidateURL(url: String) -> Observable<LinkModel?>{
        var realURL = url
        
        if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
            realURL = "http://" + url
        }
        
        guard let url = URL(string: realURL) else {
            return .empty()
        }
        

        
        return AddLinkRepository.shared
            .checkURLValidation(url: url)
    }

    let disposeBag = DisposeBag()
}

struct LinkModel {
    let url: URL
    let name: String
    let imageUrl: URL?
}
