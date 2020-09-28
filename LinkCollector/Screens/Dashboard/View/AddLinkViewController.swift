//
//  AddLinkViewController.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/26.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup
import URLEmbeddedView
import AVFoundation
import Kingfisher
import RxSwift
import RxCocoa

class AddLinkViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfLink: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var siteModel = SiteModel()
    var titleString: String?
    var inputUrl: URL?
    var activating = BehaviorSubject<Bool>(value: false)
    lazy var needAnimating: Observable<Bool> = self.activating.distinctUntilChanged()
    let viewModel: AddLinkViewModelType
    var disposeBag = DisposeBag()
    
    deinit {
        NSLog("Successfully deinit")
    }
    
    static func create() -> AddLinkViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AddLinkViewController") as! AddLinkViewController
        return vc
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = AddLinkViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfLink.delegate = self
        loadingIndicator.isHidden = true
        changeBtnAddTitle(title: "검색")
        // Do any additional setup after loading the view.
        viewModel.needAnimating
            .map{!$0}
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] finished in
                print(finished)
                if finished {
                    self?.loadingIndicator.stopAnimating()
                }else{
                    self?.loadingIndicator.startAnimating()
                }
            })
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.validateURL
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let myURLString = "https://www.naver.com"
        if let myURL = URL(string: myURLString){
            if let myData = try? Data(contentsOf: myURL){
                let myImage = UIImage(data: myData)
                self.ivThumbnail.image = myImage
            }
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        NSLog("\(sender)")
    }
    @IBAction func editingDidEnd(_ sender: UITextField) {
        NSLog("\(sender)")
        if let text = sender.text{
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if(textField.isEqual(self.tfLink)){ //titleField에서 리턴키를 눌렀다면
                self.tfLink.resignFirstResponder()//컨텐츠필드로 포커스 이동
            }
            return true
        }
    

    
    
    @IBAction func saveLink(_ sender: UIButton) {
        
        if let text = sender.titleLabel?.text {
            if text == "검색" {
                updateImageView()
            }else if text == "저장",
                let titleString = titleString,
                let inputUrl = inputUrl{
                siteModel.siteDistribution(url: inputUrl, position: titleString)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateImageView(){
        if let linkText = self.tfLink.text,
            let url = URL(string: linkText){
            activating.onNext(true)
            AF.request(url,
                       method: .get,
                       parameters: nil)
                .validate()
                .responseString{response in
                    switch response.result {
                    case .success(let value):
                        var imageUrl = String()
                        if let doc: Document = try? SwiftSoup.parse(value) {
                            for row in try! doc.select("title"){
                                self.titleString = try? row.text()
                                break
                            }
                            for row in try! doc.select("meta"){
                                if let property = try? row.attr("property"),
                                    property == "og:image"{
                                    imageUrl = try! row.attr("content")
                                    continue
                                }else if let itemprop = try? row.attr("itemprop"),
                                    itemprop == "image" {
                                    continue
                                }
                            }
                            if !imageUrl.hasPrefix("http"){
                                imageUrl = "https:\(imageUrl)"
                            }
                            self.ivThumbnail.kf.setImage(with: URL(string: imageUrl)!)
                            self.changeBtnAddTitle(title: "저장")
                            self.inputUrl = url
                            self.activating.onNext(false)
                        }
                    case .failure(let error):
                        print("error: \(String(describing: error.errorDescription))")
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                    }
                }
        }
    }
    
    private func changeBtnAddTitle(title: String){
        btnAdd.setTitle(title, for: .normal)
        btnAdd.setTitle(title, for: .highlighted)
        btnAdd.setTitle(title, for: .selected)
        btnAdd.setTitle(title, for: .disabled)
    }

}
