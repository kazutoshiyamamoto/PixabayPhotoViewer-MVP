//
//  Image.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/20.
//

import Foundation

struct Image: Codable {
    var id: Int
    var tags: String
    var user: String
    var previewURL: URL
    
    init(id: Int,
         tags: String,
         user: String,
         previewURL: URL) {
        self.id = id
        self.tags = tags
        self.user = user
        self.previewURL = previewURL
    }
}
