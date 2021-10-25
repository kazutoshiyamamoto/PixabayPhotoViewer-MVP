//
//  SearchImageViewController.swift
//  PixabayPhotoViewer-MVP
//
//  Created by home on 2021/10/19.
//

import UIKit

class SearchImageViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: SearchImagePresenterInput!
    func inject(presenter: SearchImagePresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

