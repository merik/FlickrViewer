//
//  ViewController.swift
//  FlickrViewer
//
//  Created by Chi on 3/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import UIKit

class FlickrViewController: UIViewController {

    @IBOutlet weak var flickrMainViewer: FlickrMainViewer!
    @IBOutlet weak var thumbnailCollectionView: ThumbnailCollectionView!

    let presenter = FlickrPhotoPresenter()
    var photos = [PhotoViewData]()


    override func viewDidLoad() {
        super.viewDidLoad()

        thumbnailCollectionView.thumbnailDelegate = self
        flickrMainViewer.flickrMainViewerDelegate = self

        presenter.attachView(self)
        presenter.fetchPhotos()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = ""
        let titleLabel = UILabel()
        titleLabel.text = "Flickr Viewer"
        titleLabel.sizeToFit()
        titleLabel.textColor = UIColor(hex: Contants.navigationBarTintColor)
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem

    }
    @IBAction func didTapOnRefreshButton(_ sender: Any) {
        presenter.fetchPhotos()
    }
    override func viewWillLayoutSubviews() {
        let width = flickrMainViewer.bounds.width
        let height = flickrMainViewer.bounds.height
        flickrMainViewer.imageSize = CGSize(width: width, height: height)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func displayPhotos() {

        thumbnailCollectionView.photos = self.photos
        flickrMainViewer.photos = self.photos
        thumbnailCollectionView.selectPhoto(at: 0)
    }

}
extension FlickrViewController: ThumbnailCollectionViewDelegate {
    func ThumbnailCollectionView(_ collectionView: ThumbnailCollectionView, didSelectItem thumbnail: PhotoViewData, at indexPath: IndexPath) {
        flickrMainViewer.showPhoto(at: indexPath.item)
    }
}

extension FlickrViewController: FlickrMainViewerDelegate {

    func FlickrMainViewer(_ collectionView: FlickrMainViewer, didScrollTo indexPath: IndexPath) {
        thumbnailCollectionView.selectPhoto(at: indexPath.item)
    }
}

extension FlickrViewController: FlickrPhotoView {
    func finishLoading() {
        /// TODO: hide loading progress
    }

    func setPhotos(photos: [PhotoViewData]) {
        self.photos = photos
        displayPhotos()

    }

    func startLoading() {
        /// TODO: show loading progress
    }
}

