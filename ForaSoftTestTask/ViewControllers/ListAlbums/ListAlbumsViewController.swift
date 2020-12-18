//
//  ListAlbumsViewController.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 09.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ListAlbumsViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private lazy var refreshControl = UIRefreshControl()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = L10n.ListAlbum.SearchBar.placeholder
        searchBar.sizeToFit()
        searchBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        searchBar.tintColor = self.view.tintColor
        return searchBar
    }()

    private let containerView = UIView()

    var collectionView: UICollectionView?

    private var albumsList: [Album] = [] {
        didSet {
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }

    private var needUpdateFrameCollection: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        addSubviews()
        configureNavigationController()
        configureCollectionView()
        setupConstraints()
        configureEvents()

        search()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        needUpdateFrameCollection = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if needUpdateFrameCollection {
            configureCollectionView()
            needUpdateFrameCollection = false
        }
    }

    private func configureUI() {
        view.backgroundColor = Asset.backgroundColor.color
        containerView.backgroundColor = Asset.backgroundColor.color
    }

    private func addSubviews() {
        view.addSubview(containerView)
    }

    private func configureNavigationController() {
        definesPresentationContext = true
        navigationItem.titleView = searchBar
    }

    private func configureCollectionView() {
        collectionView?.removeFromSuperview()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let width = (self.view.bounds.width - 32) / 2 - 1
        layout.itemSize = CGSize(width: width, height: width)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Asset.backgroundColor.color
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = self.refreshControl
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: Constants.ListAlbum.reuseIdentifier)

        self.collectionView = collectionView

        containerView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    private func configureEvents() {
        searchBar.rx.text.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] text in
            if !text.isNilOrEmpty {
                self.search(text: text)
            }
        }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
            self.search(text: self.searchBar.text)
        }).disposed(by: disposeBag)
    }

    private func search(text: String? = nil) {
        if text == nil {
            searchBar.text = Constants.ListAlbum.defaultSearchText
        }

        let searchText = text.isNilOrEmpty ? Constants.ListAlbum.defaultSearchText : text!

        searchAlbums(searchText: searchText) { [unowned self] albums in
            self.albumsList = albums
        }
    }
}

extension ListAlbumsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(text: searchBar.text)
        searchBar.endEditing(true)
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
}
