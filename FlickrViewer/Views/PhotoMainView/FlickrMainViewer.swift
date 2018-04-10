//
//  FlickrMainViewer.swift
//  FlickrViewer
//
//  Created by Chi on 3/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import UIKit

protocol FlickrMainViewerDelegate {
    func FlickrMainViewer(_ collectionView: FlickrMainViewer, didScrollTo indexPath: IndexPath)

}

class FlickrMainViewer: UICollectionView {

    private let cellName = "FlickrMainViewerCell"
    var photos: [PhotoViewData] = [PhotoViewData]() {
        didSet {
            reloadData()
        }
    }

    var flickrMainViewerDelegate: FlickrMainViewerDelegate?
    var imageSize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            guard let flowLayout = self.collectionViewLayout as? FlickrMainViewerLayout else {
                return
            }
            flowLayout.itemSize = imageSize
            flowLayout.invalidateLayout()
        }
    }

    func configLayout() {
        let layout  = FlickrMainViewerLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = imageSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionViewLayout = layout
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        self.dataSource = self
        self.delegate = self
        configLayout()
    }

    func showPhoto(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }


}
extension FlickrMainViewer: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.flickrMainViewerDelegate {
            delegate.FlickrMainViewer(self, didScrollTo: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! FlickrMainViewerCell
        cell.setPhoto(photos[indexPath.item])
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.visibleCells.count > 0 {
            if let indexPath = getCurrentCellIndexPath() {
                if let delegate = self.flickrMainViewerDelegate {
                    delegate.FlickrMainViewer(self, didScrollTo: indexPath)
                }
            }
        }
    }

    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }


    func getCurrentCellIndexPath() -> IndexPath? {
        return self.indexPathForItem(at: self.centerPoint)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.visibleCells.count > 0 {
            if let indexPath = getCurrentCellIndexPath() { 
                if let delegate = self.flickrMainViewerDelegate {
                    delegate.FlickrMainViewer(self, didScrollTo: indexPath)
                }
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


