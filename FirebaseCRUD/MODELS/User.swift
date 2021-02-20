//
//  User.swift
//  FirebaseCRUD
//
//  Created by fred on 19/02/2021.
//

import Foundation
import Firebase

class User {
    
    var ref: DocumentReference
    var uid: String
    var surname: String
    var name: String
    var profilImageUrl: String?
    
    init(_ document: DocumentSnapshot) {
        ref = document.reference
        uid = document.documentID
        let data = document.data() ?? [:]
        name = data["name"] as? String ?? ""
        surname = data["surname"] as? String ?? ""
        profilImageUrl = data["profilImageUrl"] as? String
    }
}
