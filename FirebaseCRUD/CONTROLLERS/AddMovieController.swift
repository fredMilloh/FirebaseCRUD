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
    @IBOutlet weak var partTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var directorTF: UITextField!
    @IBOutlet weak var pitchTV: UITextView!
    
    
    override func viewDidLoad() {
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMovieImage(_ sender: UIButton) {
        movieImageAlert()
        
    }
    
    
    @IBAction func sendMovie(_ sender: UIButton) {
    }
    
    func movieImageAlert() {
        let photoSourceController = UIAlertController(title: "", message: "Choississez votre image", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Appareil photo", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let albumPhotoAction = UIAlertAction(title: "Album photo", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        photoSourceController.addAction(cameraAction)
        photoSourceController.addAction(albumPhotoAction)
        
        present(photoSourceController, animated: true, completion: nil)
    }

}
extension AddMovieController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //imagePicker a un tableau d'image = info
    //l'image est soit éditée(une partie avec le zoom), ou originale
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage.withRenderingMode(.alwaysOriginal)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        dismiss(animated: true, completion: nil)
    }
}
