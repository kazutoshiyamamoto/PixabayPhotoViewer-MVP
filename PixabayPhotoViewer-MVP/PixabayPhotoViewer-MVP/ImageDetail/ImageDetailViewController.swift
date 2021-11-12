//
//  ImageDetailViewController.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/11/06.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var downloads: UILabel!
    
    private var presenter: ImageDetailPresenterInput!
    func inject(presenter: ImageDetailPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension ImageDetailViewController: ImageDetailPresenterOutput {
    func updateView(userName: String,
                    datailImage: Data,
                    tags: String,
                    views: Int,
                    downloads: Int) {
        DispatchQueue.global().async { [weak self] in
            guard let image = UIImage(data: datailImage) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.imageDetail?.image = image
                self?.userName.text = userName
                self?.tags.text = tags
                self?.views.text = String(views)
                self?.downloads.text = String(downloads)
            }
        }
    }
}
