//
//  FireDatabase.swift
//  FirebaseCRUD
//
//  Created by fred on 17/02/2021.
//

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
}
