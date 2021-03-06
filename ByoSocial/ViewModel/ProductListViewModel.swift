//
//  ProductListViewModel.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import Foundation
import UIKit
class ProductListViewModel {
    var socialModel: SocialModel
    
    var ID: Int?
    var linkurl: String?
    var mediatype: String?
    
    init(_ socialItem: SocialModel) {
        socialModel = socialItem
        
        ID = socialModel.ID
        linkurl = socialModel.linkurl
        mediatype = socialModel.mediatype
        
    }
    /**
     Creates a cellInstance method for display data on UI.
     
     - Parameter recipient: tableView, indexPath
     
     - Throws: Getting crash and error then Array don't have value and Index out of bouns exception
     
     - Returns: Cell object of the UITableViewCell
     */
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SocialTableCellView.stringRepresentation, for: indexPath) as! SocialTableCellView
        cell.setup(self)
        
        return cell
    }
    /**
     Creates a tapCell method for selecting any row in the tableView and display details of selected row.
     
     - Parameter recipient: tableView, indexPath
     
     - Throws: Getting crash and error if Array don't have value and Index out of bound exception
     
     - Returns:
     */
    func tapCell(_ tableView: UITableView, indexPath: IndexPath) {
        print("Tapped a cell")
    }
}
