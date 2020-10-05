//
//  WaitingChatsNavigation.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 05.10.2020.
//

import Foundation
import UIKit

protocol WaitingChatsNavigation: class {
    func removeWaitingChat(chat: MChat)
    func chatToActive(chat: MChat)
}
