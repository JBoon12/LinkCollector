//
//  SiteRepository.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/25.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift


class SiteRepository {
    static let coupang = "쿠팡"
    static let naverStore = "네이버스토어"
    static let youtube = "유튜브"
    static let naver = "네이버"
    static let other = "기타"
    
    static func getSiteList() -> [String] {
        return [coupang, naverStore, youtube, naver, other]
    }
    
//    static func vaildateURLRx(_ url:URL) -> Observable<Document> {
//        return Observable.create { emitter in
//            validateURL(url, onComplete: { result in
//                switch result{
//                case let .success(doc):
//                    emitter.onNext(doc)
//                    emitter.onCompleted()
//                case let .failure(error):
//                    emitter.onError(error)
//                }
//            })
//            return Disposables.create()
//        }
//    }
//    
//    static func validateURL(_ url: URL, onComplete: @escaping (Result<Document, Error>) -> Void) {
//        AF.request(url,
//               method: .get,
//               parameters: nil)
//        .validate()
//        .responseString{response in
//            switch response.result {
//            case .success(let value):
//                if let doc: Document = try? SwiftSoup.parse(value) {
//                    onComplete(.success(doc))
//                }else{
//                    let httpResponse = response.response!
//                    onComplete(.failure(NSError(domain: "no data",
//                                                code: httpResponse.statusCode,
//                                                userInfo: nil)))
//                }
//            case .failure(let error):
//                onComplete(.failure(error))
//            }
//        }
//    }
}
