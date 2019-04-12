//
//  String+AddText.swift
//  Tut3MyLocations
//
//  Created by luan on 6/30/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import Foundation

extension String {
    mutating func addText(text: String?, withSeparator separator: String = "") {
        if let text = text where !text.isEmpty {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}