//
//  SearchImagePresenter.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/22.
//

import Foundation

protocol SearchImagePresenterInput {
    var numberOfImages: Int { get }
    func image(forRow row: Int) -> Image?
    func didSelectRow(at indexPath: IndexPath)
    func didTapSearchButton(text: String?)
}

// Presenterの出力値を使うViewの処理
protocol SearchImagePresenterOutput: AnyObject {
    func updateImages(_ images: [Image])
    func transitionToImageDetail(imageId: Int)
}

final class SearchImagePresenter: SearchImagePresenterInput {
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
    
    func image(forRow row: Int) -> Image? {
        guard row < images.count else { return nil }
        return images[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let image = image(forRow: indexPath.row) else { return }
        view.transitionToImageDetail(imageId: image.id)
    }
    
    func didTapSearchButton(text: String?) {
        guard let query = text else { return }
        guard !query.isEmpty else { return }
        
        model.fetchImage(query: query) { [weak self] result in
            switch result {
            case .success(let images):
                self?.images = images
                
                DispatchQueue.main.async {
                    self?.view.updateImages(images)
                }
            case .failure(let error):
                // TODO: Error Handling
                print(error)
                ()
            }
        }
    }
}
