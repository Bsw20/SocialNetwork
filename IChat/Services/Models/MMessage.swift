//
//  MMessage.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 05.10.2020.
//

import Foundation
import UIKit

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUsername: String
    let sentDate: Date
    let id: String?
    
    var representation: [String : Any] {
        var rep:[String: Any] = ["content": content]
        rep["senderId"] = senderId
        rep["senderUsername"] = senderUsername
        rep["sentDate"] = sentDate
        rep["id"] = id
        
        return rep
    
    }
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
    }
}
