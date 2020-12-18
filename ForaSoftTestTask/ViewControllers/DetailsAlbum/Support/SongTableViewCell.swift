//
//  SongTableViewCell.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 18.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit
import DTModelStorage

class SongTableViewCell: UITableViewCell, ModelTransfer {

    private lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }()

    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var durationTrackLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.3)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialization()
    }

    private func initialization() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        textStackView.addArrangedSubview(singerNameLabel)
        textStackView.addArrangedSubview(trackNameLabel)
        textStackView.addArrangedSubview(durationTrackLabel)

        contentView.addSubview(artworkImageView)
        contentView.addSubview(textStackView)
    }

    private func setupConstraints() {
        artworkImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(Constants.artworkSize)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        textStackView.snp.makeConstraints { make in
            make.top.equalTo(artworkImageView.snp.top).offset(8)
            make.leading.equalTo(artworkImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }

    func update(with model: Song) {
        artworkImageView.kf.setImage(with: model.imageURL)

        singerNameLabel.text = L10n.SongCell.singer(model.singer)
        trackNameLabel.text = model.songName
        durationTrackLabel.text = L10n.SongCell.duration(model.trackTimeToString)
    }

}
