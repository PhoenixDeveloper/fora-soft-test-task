//
//  ListAlbumsViewController+Routing.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 18.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit

extension ListAlbumsViewController {
    func goToDetailsAlbumScreen(album: Album) {
        let detailsAlbumVC = DetailsAlbumViewController()
        detailsAlbumVC.album = album

        navigationController?.pushViewController(detailsAlbumVC, animated: true)
    }
}
