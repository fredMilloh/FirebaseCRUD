//
//  ProfilController.swift
//  FirebaseCRUD
//
//  Created by fred on 18/02/2021.
//

import UIKit

class ProfilController: UIViewController {
    
    var controller: ProfilController?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func disconnect(_ sender: UIButton) {
        if FireAuth().isAuth() {
            FireAuth().signOut()
           performSegue(withIdentifier: "ToRoot", sender: nil)
            
        }
    }
    
    

}
