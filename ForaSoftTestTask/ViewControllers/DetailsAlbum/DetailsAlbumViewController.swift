//
//  DetailsAlbumViewController.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 18.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DTTableViewManager

class DetailsAlbumViewController: UIViewController, DTTableViewManageable {

    var album: Album!

    private let disposeBag = DisposeBag()

    private var refreshControl = UIRefreshControl()

    lazy var tableView: UITableView! = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.refreshControl = self.refreshControl
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        addSubviews()
        setupConstraints()

        configureTableView()
        configureEvents()

        updateData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        DispatchQueue.main.async {
          self.tableView.tableHeaderView?.layoutIfNeeded()
          self.tableView.tableHeaderView = self.tableView.tableHeaderView
        }
    }

    private func configureEvents() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
            self.updateData()
        }).disposed(by: disposeBag)

        manager.didSelect(SongTableViewCell.self) { _, model, _ in
            if let url = model.trackURL {
                UIApplication.shared.open(url)
            }
        }
    }

    private func configureUI() {
        title = L10n.ListSongs.songsList
        view.backgroundColor = Asset.backgroundColor.color
        tableView.backgroundColor = Asset.backgroundColor.color
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func configureTableView() {
        manager.memoryStorage.setSectionHeaderModels([album.collectionName])
        manager.register(SongTableViewCell.self)
    }

    private func updateData() {
        refreshControl.beginRefreshing()
        ApiService.standart.getSongs(albumName: album.collectionName, albumId: album.id) { [weak self] songs, error in

            if let error = error {
                MessageManager.standart.showNetworkError(message: error.localizedDescription)
                self?.refreshControl.endRefreshing()
                return
            }

            guard let songs = songs else {
                MessageManager.standart.showError(message: L10n.Error.clientError)
                self?.refreshControl.endRefreshing()
                return
            }

            self?.manager.memoryStorage.setItems(songs)
            self?.refreshControl.endRefreshing()
        }
    }
}
