//
//  SearchImagePresenter.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/22.
//

import Foundation

protocol SearchImagePresenterInput {
    var query: String? { get }
    var pagination: Pagination? { get }
    var isFetching: Bool { get }
    var numberOfImages: Int { get }
    func image(forItem item: Int) -> Image?
    func didSelectItem(at indexPath: IndexPath)
    func searchImages(query: String?, page: Int)
    func clearImages()
}

// Presenterの出力値を使うViewの処理
protocol SearchImagePresenterOutput: AnyObject {
    func updateImages(_ images: [Image])
    func transitionToImageDetail(image: Image)
}

final class SearchImagePresenter: SearchImagePresenterInput {
    private(set) var query: String?
    private(set) var pagination: Pagination?
    private(set) var isFetching = false
    
    private(set) var images: [Image] = []
    
    private weak var view: SearchImagePresenterOutput!
    private var model: SearchImageModelInput
    
    init(view: SearchImagePresenterOutput, model: SearchImageModelInput) {
        self.view = view
        self.model = model
    }
    
    var numberOfImages: Int {
        return images.count
    }
    
    func image(forItem item: Int) -> Image? {
        guard item < images.count else { return nil }
        return images[item]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let image = image(forItem: indexPath.row) else { return }
        view.transitionToImageDetail(image: image)
    }
    
    func searchImages(query: String?, page: Int) {
        guard let query = query else { return }
        guard !query.isEmpty else { return }

        self.isFetching = true

        model.fetchImage(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.images.append(contentsOf: response.0)
                self?.query = query
                self?.pagination = response.1

                DispatchQueue.main.async {
                    self?.view.updateImages(self!.images)
                    self?.isFetching = false
                }
            case .failure(let error):
                // TODO: Error Handling
                print(error)
                ()
            }
        }
    }
    
    func clearImages() {
        self.images = []
    }
}
