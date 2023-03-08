//
//  PaginationMock.swift
//  PixabayPhotoViewer-MVPTests
//
//  Created by home on 2023/03/01.
//

import Foundation
@testable import PixabayPhotoViewer_MVP

extension Pagination {
    static func mock() -> Pagination {
        let p = Pagination(next: 0)
        return p
    }
}
