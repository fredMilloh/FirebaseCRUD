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
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeForm()

    }
    
//MARK: - get user
    
    func completeForm() {
        guard let email = FireAuth().myEmail() else { return }
        
        FireDatabase().getMe { (user) in
            if let me = user {
                print(me)
                print("nouveau => " + me.name)
                self.user = me
                self.nameTF.text = me.name
                self.surnameTF.text = me.surname
                self.adresseMailTF.placeholder = email
                self.pseudoTF.text = me.pseudo
                ImageLoader().loadImage(self.user?.profilImageUrl, self.profilImage)
            }
        }
    }
    
//MARK: - touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // on vérifie s'il y a un touché = le tableau de touché "Set<UITouch>" n'est pas vide = au moins 1 touché
        guard let touch = touches.first else { return }
    //on vérifie qu'il y a un user et que c'est bien moi pour changer le profil !!!
        guard let myUser = user else { return }
        guard let myId = FireAuth().myId() else { return }
        guard myId == myUser.uid else { return }
    //on définit la zône où le touché est actif
        if touch.view == profilImage {
            profilImageAlert()
            print("geste reconnu")
        } else {
            return
        }
        
    }
    
//MARK: - Alert popup imagePicker
    
    func profilImageAlert() {
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

//MARK: - buttons
    
    @IBAction func validateButton(_ sender: UIButton) {
        updateProfile(profilImage.image!)
    }
    
    
    @IBAction func disconnect(_ sender: UIButton) {
        if FireAuth().isAuth() {
            FireAuth().signOut()
           performSegue(withIdentifier: "ToRoot", sender: nil)
            
        }
    }
    
    @IBAction func updateMailButton(_ sender: UIButton) {
        print("Méthode en contruction ...")
/*
        adresseMailTF.placeholder = ""
        guard let newAdressMail = adresseMailTF.text else { return }
        FireAuth().updateUserEmail(newEmail: newAdressMail, password: "123456")
*/
    }
    
//MARK: - update profil
        
        func updateProfile(_ image: UIImage) {
            guard let uid = FireAuth().myId() else { return }
            
            let ref = FireStorage().userProfile(uid) //définit un emplacement pour l'user
            
            FireStorage().sendImageToFirebase(ref, image) { (url, error) in   //envoi l'image et récupére l'url
                if let urlString = url {
                    let data: [String: Any] = ["profilImageUrl": urlString,
                                               "name": self.nameTF.text as Any,
                                               "surname": self.surnameTF.text as Any,
                                               "pseudo": self.pseudoTF.text as Any
                                              ]
                    FireDatabase().updateUser(uid, data: data)   //met à jour le profil = ajout url + pseudo + changement
                }
            }
        }

}

//MARK: - extensions

extension ProfilController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //imagePicker a un tableau d'image = info
    //l'image est soit éditée(une partie avec le zoom), ou originale
        if let editedImage = info[.editedImage] as? UIImage {
            profilImage.image = editedImage.withRenderingMode(.alwaysOriginal)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            profilImage.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfilController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
