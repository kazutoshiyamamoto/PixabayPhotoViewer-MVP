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
        completion: @escaping (Result<[Image], Error>) -> ())
}

final class SearchImageModel: SearchImageModelInput {
    func fetchImage(
        query: String,
        completion: @escaping (Result<[Image], Error>) -> ()) {
        
        let request = SearchImagesRequest(query: query)
        
        Session().send(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
