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
    
    var completion: ((_ uid: String?, _ error: String?) -> Void)?
    
    // func qui retourne vrai ou faux si on est authentifier
    func isAuth() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    func signIn(_ mail: String, _ pwd: String, completion: ((_ uid: String?, _ error: String?) -> Void)?) {
        self.completion = completion
        Auth.auth().signIn(withEmail: mail, password: pwd, completion: handleResult(_:_:))
    }
    
    func createUser(_ mail: String, _ pwd: String, completion: ((_ uid: String?, _ error: String?) -> Void)?) {
        self.completion = completion
        Auth.auth().createUser(withEmail: mail, password: pwd, completion: handleResult(_:_:))
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signOut() : throws donc do/catch
            
        } catch {
            print(error.localizedDescription)
            
        }
    }
    
    func handleResult( _ data: AuthDataResult?, _ error: Error?) {
        if error != nil {
            self.completion?(nil, error?.localizedDescription)
        }
        if let uid = data?.user.uid {
            self.completion?(uid, nil)
        }
    }
}
