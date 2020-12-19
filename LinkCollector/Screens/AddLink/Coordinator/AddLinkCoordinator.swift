//
//  AddLinkCoordinator.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/12/19.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import Foundation
import UIKit

class AddLinkCoordinator: NSObject {
    static let coordinator = AddLinkCoordinator()
    
    func start(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AddLinkViewController") as! AddLinkViewController
        Utils.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
