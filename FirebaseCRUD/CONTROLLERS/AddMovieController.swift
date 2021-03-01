//
//  AddMovieController.swift
//  FirebaseCRUD
//
//  Created by fred on 24/02/2021.
//

import UIKit

class AddMovieController: RootController {
    
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
        guard let uid = FireAuth().myId() else { return }
                //vérifier qu'il y a au moins un champ complété ou une image
        if imageView.image != nil || titleTF.text != "" || partTF.text != "" || yearTF.text != "" || directorTF.text != "" || pitchTV.text != "" {
                //récupération de la date du jour
            let date = Date().timeIntervalSince1970
                //création du tableau de données
            var data: [String: Any] = [
                "titre": titleTF.text ?? "",
                "part": partTF.text ?? "",
                "year": yearTF.text ?? "",
                "director": directorTF.text ?? "",
                "pitch": pitchTV.text ?? "",
                "uid": uid
            ]
                //si il n'y a pas d'image, les données peuvent être envoyer à database Firestore
            if imageView.image == nil {
                FireDatabase().addMovie(data)
            } else {
                // il y a une image, on l'envoi sur Storage et on récupére son url
                let ref = FireStorage().affiche(uid, date)
                FireStorage().sendImageToFirebase(ref, imageView.image!) { (imageUrl, error) in
                    if let urlString = imageUrl {
                        data["movieImageUrl"] = urlString // on compléte le tableau de données avec l'url récupéré
                        FireDatabase().addMovie(data) // on envoi les données
                    }
                }
            }
            print("movie ajouté")
        } else {
            showAlert("erreur", "Pour envoyer un film, renseigner au moins un élément ou prenez une photo")
        }
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
    
    // cache le clavier
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
