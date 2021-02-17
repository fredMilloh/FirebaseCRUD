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
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        if FireAuth().isAuth() { // si isAuth() renvoi true
            print("auth == true")
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
        
    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        setupUI()
    }
    
    // cache le clavier
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
