//
//  FireAuth.swift
//  FirebaseCRUD
//
//  Created by fred on 17/02/2021.
//

import Foundation
import Firebase

class FireAuth {
    
    var completion: ((_ uid: String?, _ error: String?) -> Void)?

        // func qui retourne vrai ou faux si on est authentifier
    func isAuth() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
        // func pour récupérer l'Id
    func myId() -> String? {
        return Auth.auth().currentUser?.uid
    }
        // func pour récupérer l'email
    func myEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
// authentification
        
        func createUser(_ mail: String, _ pwd: String, completion: ((_ uid: String?, _ error: String?) -> Void)?) {
            self.completion = completion
            Auth.auth().createUser(withEmail: mail, password: pwd, completion: handleResult(_:_:))
        }
        
        func handleResult( _ data: AuthDataResult?, _ error: Error?) {
            if error != nil {
                self.completion?(nil, error?.localizedDescription)
            }
            if let uid = data?.user.uid {
                self.completion?(uid, nil)
            }
        }
    
// connexion
        
        func signIn(_ mail: String, _ pwd: String, completion: ((_ uid: String?, _ error: String?) -> Void)?) {
            self.completion = completion
            Auth.auth().signIn(withEmail: mail, password: pwd, completion: handleResult(_:_:))
        }
    
//MARK: - déconnexion
        
        func signOut() {
            do {
                try Auth.auth().signOut() // signOut() : throws donc do/catch
            } catch {
                printToConsole(message: "\(error.localizedDescription)")
            }
        }
    
//MARK:- changer adresse mail
    
    func updateUserEmail(newEmail: String, password: String) {
            //obtenir le credential (identifiants)
        guard let currentEmail = myEmail() else { return }
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
        
            // ré-authentifier l'utilisateur, pour avoir une auth récente necessaire au changement email/password
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if error != nil {
                self.printToConsole(message: "ERREUR:  \(String(describing: error?.localizedDescription)) pour la mise à jour")
                return
            }
                //mise à jour avec envoi d'un email
            Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail, completion: nil)
            self.printToConsole(message: "message envoyé")
                
                //mise à jour de l'email
            /*
            Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
                if error != nil {
                    self.printToConsole(message: "ERREUR:  \(String(describing: error?.localizedDescription)) pour la mise à jour")
                } else {
                    self.printToConsole(message: "email mis à jour")
                }
            })
            */
        })
    }
    
    
    func printToConsole(message : String) {
           #if DEBUG
               print(message)
           #endif
       }
}
