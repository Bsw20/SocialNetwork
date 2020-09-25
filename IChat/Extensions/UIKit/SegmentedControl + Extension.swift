//
//  SegmentedControl + Extension.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 24.09.2020.
//

import UIKit

extension UISegmentedControl {
    
    convenience init(first: String, second: String) {
        self.init()
        insertSegment(withTitle: first, at: 0, animated: true)
        insertSegment(withTitle: second, at: 1, animated: true)
        selectedSegmentIndex = 0
    }
}
