//
//  Movie.swift
//  FirebaseCRUD
//
//  Created by fred on 24/02/2021.
//

import Foundation
import Firebase

class Movie {
    
    var ref: DocumentReference
    var uid: String
    var title: String
    var part: String
    var year: String
    var director: String
    var pitch: String
    var movieImageUrl: String?
    
    init(_ document: DocumentSnapshot) {
        ref = document.reference
        uid = document.documentID
        let data = document.data() ?? [:]
        title = data["title"] as? String ?? ""
        part = data["part"] as? String ?? ""
        year = data["year"] as? String ?? ""
        director = data["director"] as? String ?? ""
        pitch = data["pitch"] as? String ?? ""
        movieImageUrl = data["profilImageUrl"] as? String
    }
}
