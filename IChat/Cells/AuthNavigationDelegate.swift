//
//  AuthNavigationDelegate.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 01.10.2020.
//

import Foundation
import UIKit

protocol AuthNavigationDelegate: class {
    func toLoginVC()
    func toSignUpVC()
}
