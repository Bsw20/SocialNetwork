//
//  MMessage.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 05.10.2020.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUsername: String
    let sentDate: Date
    let id: String?
    
    var representation: [String : Any] {
        var rep:[String: Any] = ["content": content]
        rep["senderID"] = senderId
        rep["senderName"] = senderUsername
        rep["created"] = sentDate
        
        return rep
    
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else { return nil }
        guard let senderUsername = data["senderUsername"] as? String else { return nil }
        guard let content = data["content"] as? String else { return nil }
        guard let senderID = data["senderID"] as? String else { return nil }
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        self.senderId = senderID
        self.senderUsername = senderUsername
        self.content = content
    }
    
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
    }
}
