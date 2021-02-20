//
//  FireDatabase.swift
//  FirebaseCRUD
//
//  Created by fred on 17/02/2021.
//

import Foundation
import UIKit
import Firebase

class FireDatabase {
    
    // chemin d'accès à la base du projet
    let base = Firestore.firestore()
    
    // chemin d'accès à la collection nommée "users"
    var usersCollection: CollectionReference {
        return base.collection("users")
    }
    
    func addUser(_ uid: String, data: [String: Any]) {
        usersCollection.document(uid).setData(data)
        // dans la collection "users", on créé un document attaché à l'uid de Auth
        // ce document comprendra un tableau de data, exemple : [name: wood, surname: matt]
    }
    
    typealias UserCompletion = (_ user: User?) -> Void
    
    func getMe(completion: UserCompletion?) {
        if let uid = FireAuth().myId() {
            usersCollection.document(uid).addSnapshotListener { (doc, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completion?(nil)
                }
                if doc != nil {
                    print(doc!.data() as Any)
                    let newUser = User(doc!)
                    print(newUser.name)
                    completion?(newUser)
                }
            }
        } else {
            completion?(nil)
        }
    }
}
