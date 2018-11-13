//
//  SocialTableCellView.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import UIKit
import JPVideoPlayer
class SocialTableCellView: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var btnVideoPlay: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(_ socialViewModel: SocialListViewModel) {
        self.selectionStyle = .none
        lblTitle.text = "Byo Offical"
        lblTime.text = "1 Day"
        lblLocation.text = "Haryana, IN"
        if let type = socialViewModel.mediatype {
            if type == 1 {
                if let url = socialViewModel.linkurl {
                    guard let feedURL = url.makeURL()  else {
                        imgView.image = AssetsImages.kloading
                        imgView.isHidden = true
                        return
                    }
                    imgView.imageWithURL(url: feedURL, placeholder: AssetsImages.kloading, handler: nil)
                }
            }
            else
            {
                imgView.image = AssetsImages.kPlaceholder
                if let url = socialViewModel.linkurl {
                    guard let feedURL = url.makeURL()  else {
                        imgView.isHidden = true
                        return
                    }
                    self.jp_videoURL = feedURL
                    self.jp_videoPlayView = self.imgView
                }
            }
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        lblTitle.text = ""
        lblTime.text = ""
        lblLocation.text = ""
        
    }
}
class CenterScaleToFitImageView: UIImageView {
    override var bounds: CGRect {
        didSet {
            adjustContentMode()
        }
    }
    
    override var image: UIImage? {
        didSet {
            adjustContentMode()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            self.clipsToBounds = true
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    func adjustContentMode() {
        guard let image = image else {
            return
        }
        if image.size.width > bounds.size.width ||
            image.size.height > bounds.size.height {
            contentMode = .scaleAspectFit
        } else {
            contentMode = .scaleAspectFill
        }
        self.clipsToBounds = true
    }
}
