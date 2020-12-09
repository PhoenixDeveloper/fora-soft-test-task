//
//  ListAlbumsViewController.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 09.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit
import SnapKit

class ListAlbumsViewController: UIViewController {

    private lazy var refreshController = UIRefreshControl()

    private lazy var searchController: UISearchController = {
        let seacrhController = UISearchController(searchResultsController: self)

        seacrhController.searchBar.delegate = self
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.searchBar.placeholder = L10n.ListAlbum.SearchBar.placeholder
        seacrhController.searchBar.sizeToFit()
        seacrhController.searchBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        seacrhController.searchBar.tintColor = self.view.tintColor
        return seacrhController
    }()

    private let containerView = UIView()

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.containerView.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = self.refreshController
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: Constants.ListAlbum.reuseIdentifier)
        return collectionView
    }()

    private var albumsList: [Album] = [] {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationController()
        configureCollectionView()
        setupConstraints()
    }

    private func configureNavigationController() {
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
    }

    private func configureCollectionView() {
        view.addSubview(containerView)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}

extension ListAlbumsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else {
            return
        }

        refreshController.beginRefreshing()

        searchAlbums(searchText: searchText) { [unowned self] albums in
            self.albumsList = albums
            self.refreshController.endRefreshing()
        }
    }
}

extension ListAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albumsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ListAlbum.reuseIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        albumCell.update(album: albumsList[indexPath.row])
        return albumCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (view.bounds.width / 2) - 24
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
