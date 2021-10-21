//
//  SearchImagesRequest.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/20.
//

import Foundation

struct SearchImagesRequest: Request {
    typealias Response = ItemsResponse<Image>

    let method: HttpMethod = .get
    let path = ""

    var queryParameters: [String : String]? {
        let params: [String: String] = ["q": query, "key": key]
        return params
    }

    let query: String
    let key: String

    init(query: String, key: String) {
        self.query = query
        self.key = key
    }
}
