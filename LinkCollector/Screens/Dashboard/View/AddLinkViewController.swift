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
import RxKingfisher

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
    var viewModel: AddLinkViewModelType
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
        
        bindData()
    }
    
    private func bindData() {
        let searchURL = BehaviorSubject<URL?>(value: nil)
        viewModel.validateURL = searchURL.distinctUntilChanged()
        
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
        
        viewModel.imageURL
            .map{$0}
            .bind(to: ivThumbnail.kf.rx.image(options: [.transition(.fade(0.2)),
                                                        .keepCurrentImageWhileLoading,
                                                        .forceTransition]))
            .disposed(by: disposeBag)
        
        let btntap = btnAdd.rx.tap
            .flatMap{Observable.from(optional: self.tfLink.text)}
            .map{string in URL(string: string)}
        
        btntap.bind(to: viewModel.validateInputURL).disposed(by: disposeBag)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.tfLink)){ //titleField에서 리턴키를 눌렀다면
            self.tfLink.resignFirstResponder()//컨텐츠필드로 포커스 이동
        }
        return true
    }

    private func changeBtnAddTitle(title: String){
        btnAdd.setTitle(title, for: .normal)
        btnAdd.setTitle(title, for: .highlighted)
        btnAdd.setTitle(title, for: .selected)
        btnAdd.setTitle(title, for: .disabled)
    }

}
