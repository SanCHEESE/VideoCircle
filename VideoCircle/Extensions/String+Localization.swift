//
//  String+Localization.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation

extension String {
    private var nonLocalizedFormat: String {
        get {
            #if DEBUG
            return "**\(self)**"
            #else
            return "\(self)"
            #endif
        }
    }

    var localized: String {
        get {
            return NSLocalizedString(self, tableName: "Localizable", value: self.nonLocalizedFormat, comment: "")
        }
    }

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: self.nonLocalizedFormat, comment: "")
    }
}
