//
//  EmptyStateView.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 22.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    private let imageView = UIImageView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.black.withAlphaComponent(0.3)
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(titleLabel)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY).offset(-48)
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(28)
            make.centerX.equalTo(imageView.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(64)
        }
    }

    func reset() {
        titleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        titleLabel.text = .empty
        imageView.image = nil
    }

    func selectType(type: EmptyStateType) {
        switch type {
        case .search:
            titleLabel.text = L10n.ListAlbums.EmptyState.text
            imageView.image = Asset.searchEmptyState.image
        case .custom(let image, let title):
            titleLabel.text = title
            imageView.image = image
        }
    }
}

enum EmptyStateType {
    case search
    case custom(image: UIImage?, title: String?)
}
