//
//  Image.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/20.
//

import Foundation

struct Image: Codable {
    var id: Int
    var tag: String
    var user: String
    var previewURL: URL
    
    init(id: Int,
         tag: String,
         user: String,
         previewURL: URL) {
        self.id = id
        self.tag = tag
        self.user = user
        self.previewURL = previewURL
    }
}
