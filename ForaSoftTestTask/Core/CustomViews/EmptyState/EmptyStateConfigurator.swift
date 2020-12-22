//
//  EmptyStateConfigurator.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 22.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit

protocol Chain {
    var nextHandler: Chain? {get set}
    func handle()
}

class EmptyStateConfigurator: Chain {
    private weak var emptyStateView: EmptyStateView?
    private let needShowEmptyState: () -> Bool
    private let hiddenContent: [UIView]?
    private let configure: ((Bool) -> Void)?

    var nextHandler: Chain?

    init(emptyStateView: EmptyStateView,
                hiddenContent: [UIView]? = nil,
                needShowEmptyState: @escaping () -> Bool = { () -> Bool in true },
                configure: ((Bool) -> Void)? = nil) {
        self.emptyStateView = emptyStateView
        self.needShowEmptyState = needShowEmptyState
        self.hiddenContent = hiddenContent
        self.configure = configure
    }

    func orElse(_ configurator: EmptyStateConfigurator) -> EmptyStateConfigurator {
        nextHandler = configurator
        return self
    }

    func handle() {
        let needShowEmptyState = self.needShowEmptyState()
        configure?(needShowEmptyState)
        for view in hiddenContent ?? [] {
            view.isHidden = needShowEmptyState
        }
        emptyStateView?.isHidden = !needShowEmptyState
        if !needShowEmptyState { nextHandler?.handle() }
    }
}
