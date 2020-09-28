//
//  MUser.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 28.09.2020.
//

import Foundation
import UIKit

struct MUser: Hashable, Decodable {
    var username: String
    var avatarStringURL: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
}
