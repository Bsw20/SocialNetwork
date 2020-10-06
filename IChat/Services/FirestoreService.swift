//
//  FirestoreService.swift
//  IChat
//
//  Created by Ярослав Карпунькин on 01.10.2020.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    var currentUser: MUser!
    
    func getUserData(user: User, complection: @escaping(Result<MUser, Error>) -> Void) {
        usersRef.document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    complection(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                self.currentUser = mUser
                complection(.success(mUser))
            } else {
                complection(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, complection: @escaping(Result<MUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex) else{
            complection(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            complection(.failure(UserError.photoNotExist))
            return
        }
        
        var mUser = MUser(username: username!,
                          email: email,
                          avatarStringURL: "Not exist",
                          description: description!,
                          sex: sex!,
                          id: id)
        
        StorageService.shared.upload(photo: avatarImage!) { (result) in
            switch result {
            
            case .success(let url):
                mUser.avatarStringURL = url.absoluteString
                self.usersRef.document(mUser.id).setData(mUser.representation) { (error) in
                    if let error = error {
                        complection(.failure(error))
                    } else {
                        complection(.success(mUser))
                    }
                }
            case .failure(let error):
                complection(.failure(error))
            }
        }
        

    }
    
    func createWaitingChat(message: String, receiver: MUser, complection: @escaping(Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username, friendAvatarStringURL: currentUser.avatarStringURL, lastMessageContent: message.content, friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation){ (error) in
            if let error = error {
                complection(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    complection(.failure(error))
                    return
                }
            }
            complection(.success(Void()))
            
        }
    }
    
    func deleteWaitingChat(chat: MChat, completion: @escaping(Result<Void, Error>) -> Void) {
        waitingChatsRef.document(chat.friendId).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, complection: completion)
        }
    }
    
    func deleteMessages(chat: MChat, complection: @escaping(Result<Void, Error>) -> Void) {  //replace 'complection' with 'completion'
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else  { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            complection(.failure(error))
                            return
                        }
                        complection(.success(Void()))
                    }
                }
            case .failure(let error):
                complection(.failure(error))
            }
        }
    }
    
    func getWaitingChatMessages(chat: MChat, completion: @escaping(Result<[MMessage], Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [MMessage]()
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot!.documents {  //handle that !
                guard let message = MMessage(document: document) else { return }
                print("Message parsed")
                messages.append(message)
            }
            
            completion(.success(messages))
            
            
        }
    }
    
    func changeToActive(chat: MChat, completion: @escaping(Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {
                    
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { (result) in
                            switch result {
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping(Result<Void, Error>) -> Void) {
        let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
        activeChatsRef.document(chat.friendId).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
        
        for message in messages {
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
            completion(.success(Void()))
        }
    }
    
}
