//
//  DashboardViewController.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/25.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import UIKit
import RealmSwift

class DashboardViewController: UIViewController {
    @IBOutlet weak var tbSiteList: UITableView!
    @IBOutlet weak var barBtnAdd: UIBarButtonItem!
    @IBOutlet weak var lbNoLink: UILabel!
    
    private var arrSiteList:[String] = []
    private var siteModel:SiteModel = SiteModel()
    private var registedSiteList:[String] = []
    
    private var viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDelegate()
        setUI()
        setDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDatasource()
        tbSiteList.reloadData()
    }
    
    func setDelegate() {
        tbSiteList.delegate = self
        tbSiteList.dataSource = self
    }
    
    func setUI() {
        tbSiteList.tableFooterView = UIView.init(frame:CGRect.zero)
        
        
        if(viewModel.links.count == 0){
            lbNoLink.isHidden = false
            tbSiteList.isHidden = true
        }else{
            lbNoLink.isHidden = true
            tbSiteList.isHidden = false
        }
    }
    
    func setDatasource() {
        registedSiteList.removeAll()
        arrSiteList.removeAll()
        
        arrSiteList = viewModel.allPrimaryKey
        for str in arrSiteList{
            if viewModel.hasLinks(in: str){
                registedSiteList.append(str)
            }
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.registedSiteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbSiteList.dequeueReusableCell(withIdentifier: "SiteListCell") as! SiteListCustomCell
        
        cell.lbSiteName.text = self.registedSiteList[indexPath.row]
        cell.lbNumOfLink.text = String(self.viewModel.amountOfLinks(in: self.registedSiteList[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailListViewController") as! DetailListViewController
        vc.strSite = siteModel.generateKey(key: self.registedSiteList[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class SiteListCustomCell: UITableViewCell {
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbSiteName: UILabel!
    @IBOutlet weak var lbNumOfLink: UILabel!
}

