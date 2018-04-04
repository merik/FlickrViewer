//
//  FlickrPhotoPresenter.swift
//  FlickrViewer
//
//  Created by Chi on 4/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import Foundation

struct PhotoViewData {
    let url: String
}

protocol FlickrPhotoView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setPhotos(photos: [PhotoViewData])
}

class FlickrPhotoPresenter {

    weak private var flickrPhotoView: FlickrPhotoView?

    func attachView(_ view: FlickrPhotoView) {
        flickrPhotoView = view
    }

    func detachView() {
        flickrPhotoView = nil
    }

    func fetchPhotos() {
        flickrPhotoView?.startLoading()
        DataManager.shared.fetchPhotos().then { (photos) -> Void in
            self.flickrPhotoView?.finishLoading()
            let data = photos.map {
                return PhotoViewData(url: $0.media!.m)
            }
            self.flickrPhotoView?.setPhotos(photos: data)
        }.catch { error in
            self.flickrPhotoView?.finishLoading()
        }
    }
}
