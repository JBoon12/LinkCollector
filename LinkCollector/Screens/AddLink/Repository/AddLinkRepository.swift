//
//  File.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/12/19.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Kanna

class AddLinkRepository: NSObject {
    static let shared = AddLinkRepository()
    
    func checkURLValidation(url: URL) -> Observable<LinkModel?> {
        return Observable.create{ observer in
            
            AF.request(url, method: .get)
                .validate(statusCode: 200..<300)
                .responseString{ response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let doc = try Kanna.HTML(html: data, encoding: .utf8)
                            var imageLink = ""
                            for link in doc.xpath("//meta[@property='og:image']") {
                                imageLink = link["content"] ?? ""
                            }
                            observer.onNext(LinkModel(url: response.response?.url ?? url, name: "구글", imageUrl: URL(string: imageLink)))
                        }catch{
                            observer.onNext(nil)
                        }
                    case .failure:
                        observer.onNext(nil)
                    }
                    observer.onCompleted()
                }
            
            return Disposables.create()
        }
    }
    
}
