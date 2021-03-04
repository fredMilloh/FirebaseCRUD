//
//  RootController.swift
//  FirebaseCRUD
//
//  Created by fred on 17/02/2021.
//

import UIKit

class RootController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(_ titre: String?, _ message: String?) {
        let alert = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "retour", style: .destructive, handler: { (action) in
            alert.removeFromParent()
    }))
    self.present(alert, animated: true, completion: nil)
        
    }
}

