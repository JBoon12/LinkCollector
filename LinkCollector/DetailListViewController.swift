//
//  DetailListViewController.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/31.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class DetailListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tbLinkList: UITableView!
    
    
    var strSite = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tbLinkList.delegate = self
        tbLinkList.dataSource = self
        tbLinkList.tableFooterView = UIView.init(frame:CGRect.zero)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let link = realm.object(ofType: Link.self, forPrimaryKey: strSite)
        guard let gLink = link else {
            return 0
        }
        return gLink.myLink.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbLinkList.dequeueReusableCell(withIdentifier: "DetailListCell") as! DetailListCell
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            let link = realm.object(ofType: Link.self, forPrimaryKey: strSite)
            
            try! realm.write{
                if let link = link{
                    link.myLink.remove(at: indexPath.row)
                    if link.myLink.count == 0{
                        realm.delete(link)
                    }
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }

}

class DetailListCell: UITableViewCell {
    @IBOutlet weak var vURL: UIView!
}
