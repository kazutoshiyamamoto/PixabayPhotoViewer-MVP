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

}
