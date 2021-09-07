//
//  SearchController.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class SearchController: UIViewController {

    // MARK: UI elements 􀯱
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()

        return searchController
    }()
    // MARK: Data Management 􀤃

    // MARK: View life cycle 􀐰

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Rechercher"
        navigationItem.searchController = searchController

    }

    // MARK: Navigation 􀋒

    // MARK: Interactions 􀛹

    // MARK: UI construction 􀤋

}
