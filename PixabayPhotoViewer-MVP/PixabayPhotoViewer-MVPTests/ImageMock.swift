//
//  ImageMock.swift
//  PixabayPhotoViewer-MVPTests
//
//  Created by home on 2023/02/19.
//

import Foundation
@testable import PixabayPhotoViewer_MVP

extension Image {
    static func mock() -> Image {
        let i = Image(id: 0,
                      tags: "",
                      user: "",
                      views: 0,
                      downloads: 0,
                      previewURL: URL.init(string: "https://google.com")!,
                      webformatURL: URL.init(string: "https://google.com")!)
        return i
    }
}
