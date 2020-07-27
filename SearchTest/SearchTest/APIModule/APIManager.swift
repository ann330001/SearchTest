//
//  APIManager.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/22.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    static let instance = APIManager()
    private let key = "98bea9bc87fa291889dca635ef82ee5e"
    
    var searchText: String = ""
    var searchPerPage: String = ""
    var photos = [Photo]()
    var currentPage: Int = 1
    var totalPages: Int = 1
    var getImage = UIImage()
    
    func getSearchData(page:Int32) {
        let group = DispatchGroup()
        group.enter()
        
        guard let encodeUrlString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return
        }
        
        let urlStr = String(format: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=%@&page=%d&format=json&nojsoncallback=1&sort=relevance", key, encodeUrlString, searchPerPage, page)
        print(urlStr)
        if let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let searchData = try? JSONDecoder().decode(SearchData.self, from: data) {
                    self.photos = searchData.photos.photo
                    self.totalPages = searchData.photos.pages
                    self.currentPage = searchData.photos.page
                    group.leave()
                } else {
                    group.leave()
                }
            }
            task.resume()
        } else {
            print("URL failed")
            group.leave()
        }
        
        group.wait()
        
    }
    
    func downloadImage(url: URL, handler: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                handler(image)
                self.getImage = image
            } else {
                handler(nil)
            }
        }
        task.resume()
    }
}
