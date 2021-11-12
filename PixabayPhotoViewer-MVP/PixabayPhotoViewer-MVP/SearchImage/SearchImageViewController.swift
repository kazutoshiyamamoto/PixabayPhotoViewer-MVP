//
//  SearchImageViewController.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/19.
//

import UIKit

class SearchImageViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presenter: SearchImagePresenterInput!
    func inject(presenter: SearchImagePresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        let margin: CGFloat = 5.0
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 20) / 3, height: (UIScreen.main.bounds.size.width - 20) / 3)
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionView.collectionViewLayout = flowLayout
    }
}

extension SearchImageViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.clearImages()
        presenter.searchImages(query: searchBar.text, page: 1)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

extension SearchImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectItem(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let query = presenter.query, let next = presenter.pagination?.next,
           scrollView.contentSize.height > 0 &&
            (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y &&
            !presenter.isFetching {
            presenter.searchImages(query: query, page: next)
        }
    }
}

extension SearchImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if let image = presenter.image(forItem: indexPath.row) {
            cell.configure(image: image)
        }
        
        return cell
    }
}

extension SearchImageViewController: SearchImagePresenterOutput {
    func updateImages(_ images: [Image]) {
        collectionView.reloadData()
    }
    
    func transitionToImageDetail(image: Image) {
        let imageDetailVC = UIStoryboard(
            name: "ImageDetail",
            bundle: nil)
            .instantiateInitialViewController() as! ImageDetailViewController
        let model = ImageDetailModel()
        let presenter = ImageDetailPresenter(
            image: image,
            view: imageDetailVC,
            model: model)
        imageDetailVC.inject(presenter: presenter)
        
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
}

