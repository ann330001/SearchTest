//
//  SearchData.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/22.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let farm: Int
    let secret: String
    let id: String
    let server: String
    let title: String
    var imageUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
}

struct PhotoData: Decodable {
    let photo: [Photo]
    let pages: Int
    let page: Int
}

struct SearchData: Decodable {
    let photos: PhotoData
}
