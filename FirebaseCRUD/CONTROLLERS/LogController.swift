//
//  LogController.swift
//  FirebaseCRUD
//
//  Created by fred on 17/02/2021.
//

import UIKit

class LogController: RootController {
    
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var segmented: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        updateVisible(false, mailTF)
        updateVisible(false, passWordTF)
        updateVisible(false, surnameTF)
        updateVisible(false, nameTF)
 */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        if FireAuth().isAuth() { // si isAuth() renvoi true
            toNextController()
        } else {
            // isAuth() renvoi false
            updateVisible(true, mailTF)
            updateVisible(true, passWordTF)
            // si segmented est sur 1 (création) on affiche prénom et nom
            let bool = segmented.selectedSegmentIndex != 0 // !=0 == true
            updateVisible(bool, surnameTF)
            updateVisible(bool, nameTF)
        }
    }
    // func pour afficher ou cacher les vues en fonction de la position création ou connection
    func updateVisible(_ bool: Bool, _ view: UIView) {
        view.isHidden = !bool
    }
    
    
    @IBAction func validateButton(_ sender: UIButton) {
        if let mail = mailTF.text, mail != "" {
            if let password = passWordTF.text, password != "" {
                if segmented.selectedSegmentIndex == 0 {
                    //Authentification
                    FireAuth().signIn(mail, password) { (uid, error) in
                        if error != nil {
                            self.showAlert("Erreur", "erreur lors lors de l'authentification")
                        }
                        if uid != nil {
                            self.toNextController()
                        }
                    }
                   
                } else {
                    if let surname = surnameTF.text, surname != "" {
                        if let name = nameTF.text, name != "" {
                            //Création du compte
                            FireAuth().createUser(mail, password) { (uid, error) in
                                if error != nil {
                                    self.showAlert("Erreur", "erreur lors de la création du compte")
                                }
                                if uid != nil {
                                    let data: [String: Any] = ["name": name, "surname": surname, "uid": uid!]
                                    FireDatabase().addUser(uid!, data: data)
                                    self.toNextController()
                                }
                            }
                            
                        } else {
                            //Alert pas de name
                            showAlert("Champs vide", "Merci de renseigner votre nom")
                        }
                    } else {
                        //Alert pas de surname
                        showAlert("Champs vide", "Merci de renseigner votre prénom")
                    }
                }
            } else {
                //alert pas de pwd
                showAlert("Champs vide", "Merci de renseigner votre mot de passe")
            }
        } else {
            // alert pas de mail
            showAlert("Champs vide", "Merci de renseigner votre adresse mail")
        }
    }
    
    func toNextController() {
        performSegue(withIdentifier: "ToList", sender: nil)
    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        setupUI()
    }
    
    // cache le clavier
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
