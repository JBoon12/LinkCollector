//
//  AddLinkViewModel.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/09/28.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import RxSwift

protocol AddLinkViewModelType {
    var needAnimating: Observable<Bool> { get }
    var validateURL: Observable<URL?> { get }

}

class AddLinkViewModel: AddLinkViewModelType {
    let disposeBag = DisposeBag()
    let validateURL: Observable<URL?>
    let needAnimating: Observable<Bool>
    
    let validateInputURL: AnyObserver<Void>

    init() {
        let validating = PublishSubject<Void>()
        let activating = BehaviorSubject<Bool>(value: false)
        let searchURL = BehaviorSubject<URL?>(value: nil)
        let validating1 = PublishSubject<Void>()
        
        needAnimating = activating.distinctUntilChanged()
        validateURL = searchURL.distinctUntilChanged()
        
        validateInputURL = validating.asObserver()
        
        validating
            .flatMap{Observable.from(optional: self.validateURL)}
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap{$0.map{SiteRepository.vaildateURLRx($0!)}}
            .map{$0.map{doc in
                var titleString:String?
                var imageUrl:String?
                var strings = [String?]()
                for row in try! doc.select("title"){
                    titleString = try? row.text()
                    break
                }
                for row in try! doc.select("meta"){
                    if let property = try? row.attr("property"),
                        property == "og:image"{
                        imageUrl = try! row.attr("content")
                        continue
                    }else if let itemprop = try? row.attr("itemprop"),
                        itemprop == "image" {
                        imageUrl = try? row.attr("content")
                        continue
                    }
                }
                if let image = imageUrl,
                    !image.hasPrefix("http"){
                    imageUrl = "https:\(imageUrl)"
                }
                
                
                
                }}
        
//        validating.withLatestFrom(searchURL)
//            .flatMap{Observable.from(optional: $0)}
//            .do(onNext: { _ in activating.onNext(true) })
//            .flatMap{SiteRepository.vaildateURLRx($0)}
//            .map{ doc in
//                var titleString:String?
//                var imageUrl:String?
//                var strings = [String?]()
//                for row in try! doc.select("title"){
//                    titleString = try? row.text()
//                    break
//                }
//                for row in try! doc.select("meta"){
//                    if let property = try? row.attr("property"),
//                        property == "og:image"{
//                        imageUrl = try! row.attr("content")
//                        continue
//                    }else if let itemprop = try? row.attr("itemprop"),
//                        itemprop == "image" {
//                        imageUrl = try? row.attr("content")
//                        continue
//                    }
//                }
//                if let image = imageUrl,
//                    !image.hasPrefix("http"){
//                    imageUrl = "https:\(imageUrl)"
//                }
//                strings.append(titleString)
//                strings.append(imageUrl)
//                return strings
//        }
        
    }
}
