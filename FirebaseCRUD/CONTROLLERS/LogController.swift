//
//  LogController.swift
//  FirebaseCRUD
//
//  Created by fred on 17/02/2021.
//

import UIKit

class LogController: UIViewController {
    
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
        if FireAuth().isAuth() { // si isAuth() renvoi true
            print("auth == true")
        } else {
            // isAuth() renvoi false
            print ("auth == false")
        }
    }
    
    @IBAction func validateButton(_ sender: UIButton) {
    }
    @IBAction func segmentedChanged(_ sender: Any) {
    }
    
}
