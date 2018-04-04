//
//  FlickrPhoto.swift
//  FlickrViewer
//
//  Created by Chi on 3/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import Foundation

class FlickrMedia {
    var m = ""
    init?(json: [String: Any]) {
        if let m = json["m"] as? String {
            self.m = m
        } else {
            return nil
        }
    }
}
class FlickrPhoto {
    var title = ""
    var link = ""
    var media: FlickrMedia?
    
    init?(json: [String: Any]) {
        if let title = json["title"] as? String {
            self.title = title
        }
        if let link = json["link"] as? String {
            self.link = link
        }
        if let media = json["media"] as? [String: Any] {
            self.media = FlickrMedia(json: media)
        }
        if !isValid {
            return nil
        }
    }

    var isValid: Bool {
        return (media != nil)
    }

}
