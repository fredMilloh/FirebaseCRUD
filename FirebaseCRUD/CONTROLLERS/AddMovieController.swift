//
//  AddMovieController.swift
//  FirebaseCRUD
//
//  Created by fred on 24/02/2021.
//

import UIKit

class AddMovieController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var directorTF: UITextField!
    @IBOutlet weak var pitchTV: UITextView!
    
    override func viewDidLoad() {
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMovie(_ sender: UIButton) {
    }
    
    

}
