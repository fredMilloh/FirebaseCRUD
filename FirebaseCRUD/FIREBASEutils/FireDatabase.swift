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
    
//completion
    var movieCompletion: (([Movie]?, Error?) -> Void)?
    
//CollectionReference
        // chemin d'accès à la base du projet
    let base = Firestore.firestore()
    
        // chemin d'accès à la collection nommée "users"
    var usersCollection: CollectionReference {
        return base.collection("users")
    }
        // chemin d'accés à la collection nommé "movies"
    var moviesCollection: CollectionReference {
        return base.collection("movies")
    }
    
//Query
    func movieBaseQuery() -> Query {
        return moviesCollection.order(by: "part", descending: false)
        //retourne une collection triée par épisodes croissants
    }
    
    func addUser(_ uid: String, data: [String: Any]) {
        usersCollection.document(uid).setData(data)
        // dans la collection "users", on créé un document attaché à l'uid de Auth
        // ce document comprendra un tableau de data, exemple : [name: wood, surname: matt]
    }
    
        //func qui met à jour l'user
    func updateUser(_ uid: String, data: [String: Any]) {
        usersCollection.document(uid).updateData(data)
        //update met à jour ce qui est necessaire, setData créé en effacant tout
    }
        // pour récupérer les infos de mon compte
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
    
    //pour envoyer un movie sur la database
    func addMovie(_ data: [String: Any]) {
        moviesCollection.document().setData(data)
    }
    
    func getMovies(completion: (([Movie]?, Error?) -> Void)?) {
        self.movieCompletion = completion
        movieBaseQuery().addSnapshotListener(handleListener(_:_:))
    }
    
    func handleListener(_ snapshot: QuerySnapshot?, _ error: Error?) {
        if error != nil {
            movieCompletion?(nil, error)
        }
        if snapshot != nil {
            //il y a une réponse, on transforme les snaps en Movie
            var movies: [Movie] = []        //création d'un tableau de movie vide
            let documents = snapshot!.documents //on met les snaps dans un tableau de documents
            for document in documents {
                print("doc:", document.data())
                movies.append(Movie(document))     //chaque document est mis au format Movie et ajouter au tableau Movies
            }
            movieCompletion?(movies, nil)
        }
    }
    
    func updateMovie(_ uid: String, data: [String: Any]) {
        moviesCollection.document(uid).updateData(data)
    }
}
