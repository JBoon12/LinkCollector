//
//  AddLinkViewController.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/26.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import Kingfisher


class AddLinkViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfLink: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var viewModel = AddLinkViewModel()
    var disposeBag = DisposeBag()
    
    deinit {
        NSLog("Successfully deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        
    }
    
    private func bindData() {
        tfLink.rx.text
            .compactMap{ $0 }
            .bind(to: viewModel.inputLink)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.isSaveEnabled
            .observeOn(MainScheduler.instance)
            .bind(to: btnAdd.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.isNeedLoading
            .observeOn(MainScheduler.instance)
            .map{[loadingIndicator] (value: Bool) -> Bool in
                if value {
                    loadingIndicator?.startAnimating()
                }else{
                    loadingIndicator?.stopAnimating()
                }
                return !value
            }
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        btnAdd.rx.tap
            .compactMap{[viewModel, tfLink] in
                tfLink?.resignFirstResponder()
                viewModel.isNeedLoading.onNext(true)
                return try viewModel.inputLink.value()
            }
            .flatMap(viewModel.isValidateURL(url:))
            .subscribe(onNext:{[viewModel] value in
                viewModel.isNeedLoading.onNext(false)
                viewModel.link.onNext(value)
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.link
            .map{[ivThumbnail] link in
                guard let link = link else {
                    ivThumbnail?.image = nil
                    return
                }
                ivThumbnail?.kf.setImage(with: link.imageUrl)
            }
            .subscribe()
            .disposed(by: viewModel.disposeBag)
        
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
