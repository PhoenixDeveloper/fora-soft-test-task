//
//  MessageView.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 22.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import SwiftMessages

extension MessageView {
    func customConfigureTheme(_ theme: Theme, iconStyle: IconStyle = .default) {
        let iconImage = iconStyle.image(theme: theme)
        switch theme {
        case .info:
            let backgroundColor = Asset.infoMessageColor.color
            let foregroundColor = UIColor.white
            configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor, iconImage: iconImage)
        case .success:
            let backgroundColor = Asset.successMessageColor.color
            let foregroundColor = UIColor.white
            configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor, iconImage: iconImage)
        case .warning:
            let backgroundColor = Asset.warningMessageColor.color
            let foregroundColor = Asset.warningMessageTextColor.color
            configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor, iconImage: iconImage)
        case .error:
            let backgroundColor = Asset.errorMessageColor.color
            let foregroundColor = UIColor.white
            configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor, iconImage: iconImage)
        }
        button?.backgroundColor = .clear
    }
}
