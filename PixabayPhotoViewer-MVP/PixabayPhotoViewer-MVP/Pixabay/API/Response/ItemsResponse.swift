//
//  ItemsResponse.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/20.
//

import Foundation

struct ItemsResponse<Item: Decodable>: Decodable {
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}
