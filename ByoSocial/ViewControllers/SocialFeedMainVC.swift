//
//  SocialFeedMainVC.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import UIKit
import JPVideoPlayer
class SocialFeedMainVC: UIViewController {
    
    static func storyboardInstance() -> SocialFeedMainVC {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! SocialFeedMainVC
    }
    
    @IBOutlet weak var btnLocal: UIButton!
    @IBOutlet weak var btnGlobal: UIButton!
    
    @IBOutlet weak var tblSocial: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    let serviceManager = BaseServiceLocalFile()
    
    var socialModel = [SocialModel]()
    var searchSocialModel = [SocialModel]()
    var isSearch = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ScreenTitle.home.rawValue
        btnLocal.isSelected = true
        setUpListUI()
        
        loadDataFromLocalJsonFile()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewFrame: CGRect = tblSocial.frame
        tblSocial.jp_tableViewVisibleFrame = tableViewFrame
    }
    /**
     Creates a method for setup UI of TableView.
     
     - Parameter recipient:
     
     - Throws:
     
     - Returns:
     */
    func setUpListUI()  {
        tblSocial.separatorStyle = .none
        
        tblSocial.rowHeight = UITableViewAutomaticDimension
        
        tblSocial.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblSocial.frame.size.width, height: 0))
        
        tblSocial.jp_delegate = self
        tblSocial.jp_scrollPlayStrategyType = .bestCell
    }
    /**
     Creates a method for fetch all social feeds.
     
     - Parameter recipient:
     
     - Throws: Getting error when server not responsding and something wrong on server side
     
     - Returns: Array of all socail feeds
     */
    func loadDataFromLocalJsonFile(){
        serviceManager.getDataFromJsonFile { response  in
            
            switch response {
            case .success(let result):
                self.socialModel.removeAll()
                let resource = result["resource"] as! [[String: Any]]
                resource.forEach({ feed in
                    self.socialModel.append(SocialModel(feed))
                })
                DispatchQueue.main.async {
                    self.tblSocial.reloadData()
                }
                break
            case .failure:
                Utility.showAlert(message: server_error, onView: self)
                break
            case .notConnectedToInternet:
                Utility.showAlert(message: internet_error, onView: self)
                break
            case .fileNotExist:
                Utility.showAlert(message: fileNotExist, onView: self)
                break
            }
        }
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if sender == btnLocal {
            sender.isSelected = true
            btnGlobal.isSelected = false
        }
        else {
            sender.isSelected = true
            btnLocal.isSelected = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// Mark UITableView delegate and datasource methods
extension SocialFeedMainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = isSearch ? searchSocialModel.count : socialModel.count
        if count == 0 {
            self.tblSocial.setBackgroundMessage(feedNotFound)
        }
        else{
            self.tblSocial.backgroundView = nil
        }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let feed = isSearch ? searchSocialModel[indexPath.row] : socialModel[indexPath.row]
        
        let socialListViewModel = SocialListViewModel(feed)
        return socialListViewModel.cellInstance(tableView, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}
extension SocialFeedMainVC : JPTableViewPlayVideoDelegate {
    func tableView(_ tableView: UITableView, willPlayVideoOn cell: UITableViewCell) {
        cell.jp_videoPlayView?.jp_resumeMutePlay(with: (cell.jp_videoURL)!, bufferingIndicator: nil, progressView: nil, configuration: nil)
    }
}

extension SocialFeedMainVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tblSocial.jp_scrollDidScroll()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tblSocial.jp_scrollDidEndDecelerating()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tblSocial.jp_scrollDidEndDraggingWillDecelerate(decelerate)
        
    }
}
// Mark Search bar delegate methods
extension SocialFeedMainVC : UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.endEditing(true)
        isSearch = true
        getSearchData(search: searchBar.text ?? "")
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        isSearch = false
        self.view.endEditing(true)
        tblSocial.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String) {
        let searchTxt = searchBar.text?.trim()
        searchBar.text = searchText
        isSearch = true
        performSearch(withSearchString: searchTxt ?? "")
    }
    
    fileprivate func performSearch(withSearchString searchString:String) {
        
        searchSocialModel.removeAll()
        searchSocialModel.append(contentsOf: getSearchData(search: searchString))
        DispatchQueue.main.async {
            self.tblSocial.reloadData()
        }
    }
    
    func getSearchData(search: String) -> [SocialModel] {
        
        var searchResult = [SocialModel]()
        
        for model in socialModel {
            if search.count == 0 {
                searchResult.append(model)
            }else if search.count > 0 {
                if model.linkurl.lowercased().range(of: search.lowercased()) != nil  {
                    searchResult.append(model)
                }
            }
        }
        
        return searchResult
    }
}
