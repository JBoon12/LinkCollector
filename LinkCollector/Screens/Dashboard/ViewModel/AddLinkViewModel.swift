//
//  AddLinkViewModel.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/09/28.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import RxSwift
import SwiftSoup

protocol AddLinkViewModelType {
    var needAnimating: Observable<Bool> { get }
    var validateURL: Observable<URL?> { get set }
    var imageURL: Observable<URL?> { get }
    var validateInputURL: AnyObserver<URL?> { get }
}

class AddLinkViewModel: AddLinkViewModelType {
    var validateURL: Observable<URL?>
    
    let disposeBag = DisposeBag()
    let needAnimating: Observable<Bool>
    let imageURL: Observable<URL?>
    
    let validateInputURL: AnyObserver<URL?>

    init() {
        let validating = PublishSubject<URL?>()
        let activating = BehaviorSubject<Bool>(value: false)

        let getImageURL = BehaviorSubject<URL?>(value: nil)
        
        needAnimating = activating.distinctUntilChanged()
        imageURL = getImageURL.distinctUntilChanged()
        validateURL = BehaviorSubject<URL?>(value: nil).distinctUntilChanged()
        
        validateInputURL = validating.asObserver()
        
        validating
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap{$0.map{self.validateURL($0)}!}
            .map{doc in
                var titleString:String?
                var imageString:String?
                var strings = [String?]()
                for row in try! doc.select("title"){
                    titleString = try? row.text()
                    break
                }
                for row in try! doc.select("meta"){
                    if let property = try? row.attr("property"),
                        property == "og:image"{
                        imageString = try! row.attr("content")
                        continue
                    }else if let itemprop = try? row.attr("itemprop"),
                        itemprop == "image" {
                        imageString = try? row.attr("content")
                        continue
                    }
                }
                if let image = imageString,
                    !image.hasPrefix("http"){
                    imageString = "https:\(imageString)"
                }
                
                if let imageString = imageString{
                    getImageURL.onNext(URL(string: imageString))
                }
                
                
                }
            .do(onNext: {_ in activating.onNext(false)})
            .subscribe(onNext: nil)
            .disposed(by: disposeBag)
    }
    
    func validateURL(_ url: URL) -> Observable<Document> {
        return SiteRepository.vaildateURLRx(url)
            .map{ doc in
                return doc
            }
    }
}
