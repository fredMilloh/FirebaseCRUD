//
//  FireAuth.swift
//  FirebaseCRUD
//
//  Created by fred on 17/02/2021.
//

import Foundation
import Firebase

class FireAuth {
    
//MARK: - Authentification
    // func qui retourne vrai ou faux si on est authentifier
    func isAuth() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
}
