//
//  SelfConfiguringCell.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 28.09.2020.
//

import Foundation
import UIKit

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
 
