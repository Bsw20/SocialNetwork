//
//  Label + Extension.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 21.09.2020.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
    }
}
