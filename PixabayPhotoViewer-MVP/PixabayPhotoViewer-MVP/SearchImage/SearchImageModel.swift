//
//  SearchImageModel.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/21.
//

import Foundation

protocol SearchImageModelInput {
    func fetchImage(query: String, page: Int) async throws -> ([Image], Pagination)
}

final class SearchImageModel: SearchImageModelInput {
    func fetchImage(query: String, page: Int) async throws -> ([Image], Pagination) {
        let request = SearchImagesRequest(
            query: query,
            page: page,
            perPage: 30
        )
        
        do {
            let response = try await Session().send(request)
            return (response.0.hits, response.1)
        } catch {
            throw error
        }
    }
}
