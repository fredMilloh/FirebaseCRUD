//
//  ProfilController.swift
//  FirebaseCRUD
//
//  Created by fred on 18/02/2021.
//

import UIKit
import SDWebImage

class ProfilController: UIViewController {
    
    
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var adresseMailTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var pseudoTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeForm()

    }
    
    var user: User?
    
    func completeForm() {
        FireDatabase().getMe { (user) in
            if let me = user {
                print("nouveau => " + me.name)
                self.user = me
                self.nameTF.placeholder = me.name
                self.surnameTF.placeholder = me.surname
                ImageLoader().loadImage(self.user?.profilImageUrl, self.profilImage)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // on vérifie s'il y a un touché = le tableau de touché "Set<UITouch>" n'est pas vide = au moins 1 touché
        guard let touch = touches.first else { return }
    //on vérifie qu'il y a un user et que c'est bien moi pour changer le profil !!!
        guard let myUser = user else { return }
        guard let myId = FireAuth().myId() else { return }
        guard myId == myUser.uid else { return }
    //on définit la zône où le touché est actif
        if touch.view == profilImage {
            //action
        } else {
            return
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
