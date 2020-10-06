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
import MessageKit

struct MMessage: Hashable, MessageType  {
    var sender: SenderType
    let content: String
    let sentDate: Date
    let id: String?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    
    var representation: [String : Any] {
        var rep:[String: Any] = ["content": content]
        rep["senderID"] = sender.senderId
        rep["senderName"] = sender.displayName
        rep["created"] = sentDate
        
        return rep
    
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else { return nil }
        guard let senderUsername = data["senderName"] as? String else { return nil }
        guard let content = data["content"] as? String else { return nil }
        guard let senderID = data["senderID"] as? String else { return nil }
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderID, displayName: senderUsername)
        self.content = content
    }
    
    
    init(user: MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
    
}
