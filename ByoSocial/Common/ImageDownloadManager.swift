//
//  ImageDownloadManager.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//


import UIKit

extension UIImageView {
    
    /**
     Creates a function for download the image from the server one by one using the URLSession request
     
     - Parameter: URL string of the Image
     
     - Throws: Getting error when url is not exist or image will not found
     
     - Returns: Image object
     */
    
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

