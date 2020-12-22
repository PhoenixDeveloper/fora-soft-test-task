//
//  MessageManager.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 22.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import Foundation
import SwiftMessages

final class MessageManager {

    static let standart = MessageManager()

    private init() {}

    func showSuccess(message: String) {
        let banner = createBanner()
        banner.configureContent(body: message)
        banner.customConfigureTheme(.success)
        SwiftMessages.show(config: configForBanner, view: banner)
    }

    func showInfo(message: String) {
        let banner = createBanner()
        banner.configureContent(body: message)
        banner.customConfigureTheme(.info)
        SwiftMessages.show(config: configForBanner, view: banner)
    }

    func showError(message: String) {
        let banner = createBanner()
        banner.configureContent(body: message)
        banner.customConfigureTheme(.error)
        SwiftMessages.show(config: configForBanner, view: banner)
    }

    func showWarning(message: String) {
        let banner = createBanner()
        banner.configureContent(body: message)
        banner.customConfigureTheme(.warning)
        SwiftMessages.show(config: configForBanner, view: banner)
    }

    func showRequestError(message: String) {
        let banner = createBanner()
        banner.configureContent(body: message)
        banner.customConfigureTheme(.error)
        banner.button?.isHidden = false
        SwiftMessages.show(config: configForBanner, view: banner)
    }

    func showNetworkError(message: String) {
        let banner = createBanner()
        banner.configureContent(body: message)
        banner.customConfigureTheme(.warning)
        SwiftMessages.show(config: configForBanner, view: banner)
    }

    private func createBanner() -> MessageView {
        let view: CustomMessageView = try! SwiftMessages.viewFromNib()
        view.button?.isHidden = true
        return view
    }

    private var configForBanner: SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 3)
        config.interactiveHide = true
        if let top = UIApplication.topViewController() {
            config.presentationContext = .view(top.view)
        }
        return config
    }
}

private extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}
