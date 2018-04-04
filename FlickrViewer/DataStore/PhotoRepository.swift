//
//  PhotoRepository.swift
//  FlickrViewer
//
//  Created by Chi on 4/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import Foundation
import PromiseKit

protocol PhotoRepository {
    func fetchPhotos() -> Promise<[FlickrPhoto]>
}

