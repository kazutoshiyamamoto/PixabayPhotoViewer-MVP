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

    var queryParameters: [String : String]? {
        let params: [String: String] = [
            "key": apiKey,
            "q": query
        ]
        return params
    }

    let query: String

    init(query: String) {
        self.query = query
    }
}
