//
//  UIImageView + Extension.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 21.09.2020.
//

import Foundation
import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}
