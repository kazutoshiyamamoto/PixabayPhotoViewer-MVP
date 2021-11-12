//
//  ImageDetailModel.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/11/06.
//

import Foundation

protocol ImageDetailModelInput {
    func fetchImage(url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

final class ImageDetailModel: ImageDetailModelInput {
    private var task: URLSessionTask?
    
    func fetchImage(url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        task = {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(imageData))
            }
            task.resume()
            return task
        }()
    }
}
