//
//  ThumbnailCell.swift
//  FlickrViewer
//
//  Created by Chi on 3/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import UIKit
import SDWebImage

class ThumbnailCell: UICollectionViewCell {

    private var photo: PhotoViewData!

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setPhoto(_ photo: PhotoViewData) {
        
        self.photo = photo
        thumbnailImageView.sd_setShowActivityIndicatorView(true)
        thumbnailImageView.sd_setIndicatorStyle(.gray)
        thumbnailImageView.sd_setImage(with: URL(string: photo.url), placeholderImage: nil)
    }
    func setSelected(_ selected: Bool) {
        if selected {
            selectMe()
        } else {
            deselectMe()
        }
    }
    func selectMe() {

        thumbnailImageView.layer.borderColor = UIColor.red.cgColor
        thumbnailImageView.layer.borderWidth = 2
    }
    func deselectMe() {

        thumbnailImageView.layer.borderWidth = 0
        thumbnailImageView.layer.borderColor = UIColor.clear.cgColor
    }

}
