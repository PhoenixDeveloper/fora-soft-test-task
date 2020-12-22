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

    // MARK: - Empty State

    lazy var emptyStateConfigurator: EmptyStateConfigurator = {
        EmptyStateConfigurator(
            emptyStateView: emptyStateView,
            hiddenContent: [containerView],
            needShowEmptyState: { [unowned self] in
                self.albumsList.count == 0 || self.searchBar.text.isNilOrEmpty
            },
            configure: { [unowned self] _ in
                self.emptyStateView.reset()
                self.emptyStateView.selectType(type: .search)
        })
    }()

    lazy var emptyStateView = EmptyStateView()

    // MARK: - View Controller's Fields

    private let disposeBag = DisposeBag()

    private var refreshControl = UIRefreshControl()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = L10n.ListAlbums.SearchBar.placeholder
        searchBar.sizeToFit()
        searchBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        searchBar.tintColor = self.view.tintColor
        return searchBar
    }()

    private let containerView = UIView()

    var collectionView: UICollectionView?

    private var albumsList: [Album] = [] {
        didSet {
            self.collectionView?.reloadData()
            self.emptyStateConfigurator.handle()
            self.refreshControl.endRefreshing()
        }
    }

    private var needUpdateFrameCollection: Bool = false

    // MARK: - View Controller's Methods

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

        emptyStateConfigurator.handle()
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
        view.addSubview(emptyStateView)
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

        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func configureEvents() {
        searchBar.rx.text.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] text in
            if let text = text, !text.isEmpty {
                self.search(text: text)
            } else {
                self.emptyStateConfigurator.handle()
            }
        }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
            if let text = self.searchBar.text, !text.isEmpty {
                self.search(text: text)
            }
        }).disposed(by: disposeBag)
    }

    private func search(text: String) {
        refreshControl.beginRefreshing()
        searchAlbums(searchText: text) { [weak self] albums in
            self?.albumsList = albums
        }
    }
}

extension ListAlbumsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            search(text: text)
            searchBar.endEditing(true)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToDetailsAlbumScreen(album: albumsList[indexPath.row])
    }
}
