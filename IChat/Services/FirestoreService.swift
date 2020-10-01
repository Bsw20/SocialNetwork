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
    
    func getUserData(user: User, complection: @escaping(Result<MUser, Error>) -> Void) {
        usersRef.document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    complection(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                
                complection(.success(mUser))
            } else {
                complection(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImageSrting: String?, description: String?, sex: String?, complection: @escaping(Result<MUser, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else{
            complection(.failure(UserError.notFilled))
            return
        }
        
        let mUser = MUser(username: username!,
                          email: email,
                          avatarStringURL: "Not exist",
                          description: description!,
                          sex: sex!,
                          id: id)
        
        self.usersRef.document(mUser.id).setData(mUser.representation) { (error) in
            if let error = error {
                complection(.failure(error))
            } else {
                complection(.success(mUser))
            }
        }
    }
    
}
