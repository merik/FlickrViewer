//
//  ThumbnailCollectionView.swift
//  FlickrViewer
//
//  Created by Chi on 3/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import UIKit


protocol ThumbnailCollectionViewDelegate {
    func ThumbnailCollectionView(_ collectionView: ThumbnailCollectionView, didSelectItem thumbnail: PhotoViewData, at indexPath: IndexPath)
}

class ThumbnailCollectionView: UICollectionView {

    private let cellName = "ThumbnailCell"
    private var currentSelectingItem = -1
    private let cellSize = CGSize(width: 120, height: 80)

    var photos: [PhotoViewData] = [PhotoViewData]() {
        didSet {
            currentSelectingItem = -1
            reloadData()
        }
    }

    var thumbnailDelegate: ThumbnailCollectionViewDelegate?

    func configLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = cellSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionViewLayout = layout
        self.isPagingEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.allowsMultipleSelection = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        self.dataSource = self
        self.delegate = self
        configLayout()
    }
    func refreshPhoto() {
        if currentSelectingItem < 0 {
            currentSelectingItem = 0
        }
        selectPhoto(at: currentSelectingItem, forced: true)
    }
    private func itemToIndexPath(item: Int) -> IndexPath {
        return IndexPath(item: item, section: 0)
    }

    func selectPhoto(at index: Int, forced: Bool = false) {
        guard index < photos.count, index >= 0, ((index != currentSelectingItem) || forced) else {
            return
        }
        let lastSelected = currentSelectingItem
        currentSelectingItem = index
        let currentIndexPath = itemToIndexPath(item: currentSelectingItem)

        if lastSelected >= 0 {
            if lastSelected != currentSelectingItem {
                let lastIndexPath = itemToIndexPath(item: lastSelected)
                self.reloadItems(at: [lastIndexPath, currentIndexPath])
            } else {
                self.reloadItems(at: [currentIndexPath])
            }
        } else {
            self.reloadItems(at: [currentIndexPath])
        }
        if let delegate = thumbnailDelegate {
            delegate.ThumbnailCollectionView(self, didSelectItem: photos[index], at: currentIndexPath)
        }
        self.scrollToItem(at: currentIndexPath, at: .left, animated: true)
    }

}
extension ThumbnailCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPhoto(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! ThumbnailCell
        cell.setPhoto(photos[indexPath.item])
        cell.setSelected(currentSelectingItem == indexPath.item)

        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let index = scrollView.contentOffset.x / self.cellSize.width
        let fracPart = index.truncatingRemainder(dividingBy: 1)
        var item = Int(fracPart >= 0.5 ? ceil(index) : floor(index))
        if item < 0 {
            item = 0
        }
        let indexPath = IndexPath(item: item, section: 0)
        self.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / self.cellSize.width
        let fracPart = index.truncatingRemainder(dividingBy: 1)
        var item = Int(fracPart >= 0.5 ? ceil(index) : floor(index))
        if item < 0 {
            item = 0
        }
        let indexPath = IndexPath(item: item, section: 0)
        self.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

