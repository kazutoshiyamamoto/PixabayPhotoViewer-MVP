//
//  ImageDetailPresenter.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/11/06.
//

import Foundation

protocol ImageDetailPresenterInput {
    var image: Image { get }
    func viewDidLoad()
}

protocol ImageDetailPresenterOutput: AnyObject {
    func updateView(userName: String,
                    datailImage: Data,
                    tags: String,
                    views: Int,
                    downloads: Int)
}

final class ImageDetailPresenter: ImageDetailPresenterInput {
    private(set) var image: Image
    
    private weak var view: ImageDetailPresenterOutput!
    private var model: ImageDetailModelInput
    
    init(image: Image, view: ImageDetailPresenterOutput, model: ImageDetailModelInput) {
        self.image = image
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        model.fetchImage(url: image.webformatURL) { [weak self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self?.view.updateView(userName: self!.image.user,
                                          datailImage: imageData,
                                          tags: self!.image.tags,
                                          views: self!.image.views,
                                          downloads: self!.image.downloads)
                }
            case .failure(let error):
                // TODO: Error Handling
                print(error)
                ()
            }
        }
    }
}
