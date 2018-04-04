//
//  DataManager.swift
//  FlickrViewer
//
//  Created by Chi on 4/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import Foundation
import PromiseKit

class DataManager {
    var flickrPhotoRepository: FlickrPhotoRepository
    private init() {
        flickrPhotoRepository = FlickrPhotoRepository()
    }
    static let shared = DataManager()

    func fetchPhotos() -> Promise<[FlickrPhoto]> {
        return flickrPhotoRepository.fetchPhotos()
    }
}
