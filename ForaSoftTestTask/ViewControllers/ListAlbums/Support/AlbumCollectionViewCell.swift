//
//  AlbumCollectionViewCell.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 09.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class AlbumCollectionViewCell: UICollectionViewCell {

    var needArtworkSizeSetup: Bool = false {
        didSet {
            artworkImageView.snp.removeConstraints()
            artworkImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(16)

                if needArtworkSizeSetup {
                    make.centerX.equalToSuperview()
                    make.size.equalTo(Constants.artworkSize)
                } else {
                    make.leading.trailing.equalToSuperview().inset(16)
                }
            }
        }
    }

    private lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.3)
        label.numberOfLines = 0
        return label
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .lastBaseline
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var countSongsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.3)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialization()
    }

    private func initialization() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
    }

    func update(album: Album) {
        if let url = album.artworkURL {
            artworkImageView.kf.setImage(with: url)
        }

        albumNameLabel.text = album.collectionName
        artistNameLabel.text = L10n.AlbumCell.artistName(album.artistName)
        genreLabel.text = L10n.AlbumCell.genre(album.genre)
        countSongsLabel.text = L10n.AlbumCell.countSongs(album.trackCount)
    }

    private func addSubviews() {
        infoStackView.addArrangedSubview(genreLabel)
        infoStackView.addArrangedSubview(countSongsLabel)

        contentView.addSubview(artworkImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(infoStackView)
    }

    private func setupConstraints() {
        artworkImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)

            if needArtworkSizeSetup {
                make.centerX.equalToSuperview()
                make.size.equalTo(Constants.artworkSize)
            } else {
                make.leading.trailing.equalToSuperview().inset(16)
            }

        }

        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(artworkImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}
