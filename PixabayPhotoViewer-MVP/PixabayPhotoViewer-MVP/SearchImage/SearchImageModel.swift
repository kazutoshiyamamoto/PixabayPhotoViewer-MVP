//
//  SearchImageModel.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/21.
//

import Foundation

protocol SearchImageModelInput {
    func fetchImage(
        query: String,
        page: Int,
        completion: @escaping (Result<([Image], Pagination), Error>) -> ())
}

final class SearchImageModel: SearchImageModelInput {
    func fetchImage(
        query: String,
        page: Int,
        completion: @escaping (Result<([Image], Pagination), Error>) -> ()) {
        
        let request = SearchImagesRequest(
            query: query,
            page: page,
            perPage: 30
        )
        
        Session().send(request) { result in
            switch result {
            case .success(let response):
                completion(.success((response.0.hits, response.1)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
