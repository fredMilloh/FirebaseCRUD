//
//  DetailsController.swift
//  FirebaseCRUD
//
//  Created by fred on 01/03/2021.
//

import UIKit

class DetailsController: UIViewController {

    @IBOutlet weak var titreTF: UITextField!
    @IBOutlet weak var partTF: UITextField!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var pitchTV: UITextView!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var directorTF: UITextField!
    
    var movieSelected: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        titreTF.text = movieSelected.titre
        partTF.text = movieSelected.part
        pitchTV.text = movieSelected.pitch
        yearTF.text = movieSelected.year
        directorTF.text = movieSelected.director
        ImageLoader().loadImage(self.movieSelected.movieImageUrl, self.movieImage)
    }
    
//MARK: buttons
    
    @IBAction func closeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        updateMovie()
    }
    
    @IBAction func addImage(_ sender: UITapGestureRecognizer) {
        movieImageAlert()
    }
    
    
    func updateMovie() {
        guard let uid = FireAuth().myId() else { return }
            let date = Date().timeIntervalSince1970
        
                let ref = FireStorage().affiche(uid, date)
                FireStorage().sendImageToFirebase(ref, movieImage.image!) { (imageUrl, error) in
                    
                    if let urlString = imageUrl {
                        let data: [String: Any] = [
                            "titre": self.titreTF.text ?? "",
                            "part": self.partTF.text ?? "",
                            "year": self.yearTF.text ?? "",
                            "director": self.directorTF.text ?? "",
                            "pitch": self.pitchTV.text ?? "",
                            "movieImageUrl": urlString]
            //le document actuel est modifié, faire appel à son uid et non l'uid de user
                        FireDatabase().updateMovie(self.movieSelected.uid, data: data)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
    }
        
    
//MARK: - Alert popup imagePicker
        
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
//MARK: - extensions

extension DetailsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //imagePicker a un tableau d'image = info
    //l'image est soit éditée(une partie avec le zoom), ou originale
        if let editedImage = info[.editedImage] as? UIImage {
            movieImage.image = editedImage.withRenderingMode(.alwaysOriginal)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            movieImage.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        dismiss(animated: true, completion: nil)
    }
}
extension DetailsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
