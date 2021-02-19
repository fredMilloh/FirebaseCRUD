//
//  ProfilController.swift
//  FirebaseCRUD
//
//  Created by fred on 18/02/2021.
//

import UIKit

class ProfilController: UIViewController {
    
    
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var adresseMailTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var pseudoTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var user: User?
    
    func completeForm() {
        FireDatabase().getMe { (user) in
            if let me = user {
                self.user = me
                //self.nameTF.text = me.name
                //self.surnameTF.text = me.surname
            }
        }
    }
    
    @IBAction func validateButton(_ sender: UIButton) {
    }
    
    
    @IBAction func disconnect(_ sender: UIButton) {
        if FireAuth().isAuth() {
            FireAuth().signOut()
           performSegue(withIdentifier: "ToRoot", sender: nil)
            
        }
    }
    
    

}
