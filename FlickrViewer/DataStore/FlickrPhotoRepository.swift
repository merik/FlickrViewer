//
//  FlickrPhotoRepository.swift
//  FlickrViewer
//
//  Created by Chi on 4/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import Foundation
import PromiseKit


import Foundation
import PromiseKit
import Alamofire

protocol FVErrorProtocol: Error {

    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var code: Int { get }
}
struct FVError: FVErrorProtocol {

    var localizedTitle: String
    var localizedDescription: String
    var code: Int

    init(localizedTitle: String?, localizedDescription: String, code: Int) {
        self.localizedTitle = localizedTitle ?? "Error"
        self.localizedDescription = localizedDescription
        self.code = code
    }
}

class FlickrPhotoRepository: PhotoRepository {

    let baseURL = "https://api.flickr.com/services/feeds/"

    func fetchPhotos() -> Promise<[FlickrPhoto]> {
        return Promise { fulfill, reject in
            let stEndpoint = baseURL + "photos_public.gne?format=json&nojsoncallback=1"

            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]

            Alamofire.request(stEndpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON { response in

                    if response.result.error != nil {
                        reject(self.makeStringError("No Internet connection"))
                    } else {
                        if let json = response.result.value as? [String: Any] {
                            var photos = [FlickrPhoto]()
                            if let items = json["items"] as? [[String:Any]] {
                                for item in items {
                                    if let photo = FlickrPhoto(json: item) {
                                        photos.append(photo)
                                    }
                                }
                                fulfill(photos)
                            } else {
                                reject(self.makeStringError("Error getting photos from Flickr"))
                            }

                        } else {
                            reject(self.makeStringError("Invalid data received"))
                        }
                    }
            }

        }   // return
    } // end of function



    func makeStringError(_ errorMessage: String) -> FVError {
        return FVError(localizedTitle: "FPR", localizedDescription: errorMessage, code: -1)
    }
    func makeError(errorMessage: String, errorCode: Int) -> FVError {
        return FVError(localizedTitle: "FPR", localizedDescription: errorMessage, code: errorCode)
    }
}
