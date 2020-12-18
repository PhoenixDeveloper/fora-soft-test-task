//
//  StringExtension.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 09.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import Foundation

extension String {
    static let space = " "
    static let empty = ""

    func replaceSpecialCharAndSpace() -> String {
        return self.replacingOccurrences(of: String.space, with: "+").replacingOccurrences(of: "#", with: "%23").replacingOccurrences(of: "&", with: "%26")
    }
}

extension Optional where Wrapped: StringProtocol {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
