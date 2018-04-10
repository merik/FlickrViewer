//
//  FlickrMainViewerCell.swift
//  FlickrViewer
//
//  Created by Chi on 3/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import UIKit
import SDWebImage

class FlickrMainViewerCell: UICollectionViewCell {

    private var photo: PhotoViewData!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scrollView.delegate = self
        scrollView.contentSize = photoImageView.frame.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }
    func setPhoto(_ photo: PhotoViewData) {
        self.photo = photo
        photoImageView.sd_setShowActivityIndicatorView(true)
        photoImageView.sd_setIndicatorStyle(.gray)
        photoImageView.sd_setImage(with: URL(string: photo.url), placeholderImage: nil)
        scrollView.zoomScale = 1.0
    }

}
extension FlickrMainViewerCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
