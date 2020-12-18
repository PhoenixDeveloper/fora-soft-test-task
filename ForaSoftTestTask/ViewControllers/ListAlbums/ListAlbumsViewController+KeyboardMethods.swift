//
//  ListAlbumsViewController+KeyboardMethods.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 18.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit

extension ListAlbumsViewController {
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardHeight ?? 0) + 16, right: 0)
        let scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardHeight ?? 0), right: 0)

        collectionView?.contentInset = contentInsets
        collectionView?.scrollIndicatorInsets = scrollIndicatorInsets

    }

    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.contentInset = contentInsets
        collectionView?.scrollIndicatorInsets = contentInsets
    }
}
