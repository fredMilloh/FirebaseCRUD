//
//  FireStorage.swift
//  FirebaseCRUD
//
//  Created by fred on 20/02/2021.
//

import Foundation
import Firebase

class FireStorage {
    
        //point d'entrée du storage
    var base = Storage.storage().reference()
    
        //chemin du stockage : base.child(uid) = dossier storage de l'user(uid)  .child("profilImageUrl"= dossier profilImage
    func userProfile(_ uid: String) -> StorageReference {
        return base.child(uid).child("profilImageUrl")
    }
    
        //pour les images de film =
    func affiche(_ uid: String, _ timeStamp: Double) -> StorageReference {
        return base.child(uid).child("affiche").child("\(timeStamp)")
    }
    
    
    
    typealias ImageUploadCompletion = (_ urlString: String?, _ error: Error?) -> Void
    
    func sendImageToFirebase(_ ref: StorageReference, _ image: UIImage, completion: ImageUploadCompletion?) {
        //transformer l'image en data, ici jpeg compresser à 30%
        guard let data = image.jpegData(compressionQuality: 0.25) else { return }
        //envoi des data sur storage avec la reference ref
        ref.putData(data, metadata: nil) { (storeData, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion?(nil, error)
            }
            if storeData != nil { //il y a des data
                ref.downloadURL { (url, error) in  //récupération de l'url
                    if error != nil {
                        completion?(nil, error)
                    }
                    if url != nil {
                        completion?(url!.absoluteString, nil) //transforme l'url en string
                    }
                }
            }
        }
    }
}
