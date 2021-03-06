//
//  ProfilController.swift
//  FirebaseCRUD
//
//  Created by fred on 18/02/2021.
//

import UIKit
import SDWebImage

class ProfilController: RootController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
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
        adresseMailTF.placeholder = "Saississez votre nouvelle adresse Email"
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
                    self.updateEmail()
                    
                    }
                }
            }
        
    func updateEmail() {
        // on ajoute une alerte pour demander le mot de passe nécessaire à le reconnexion
        let alert = UIAlertController(title: "Mot de Passe?", message: "Pour changer votre adresse Email, vous devez vous reconnecter, merci de saissir votre mot de passe", preferredStyle: .alert)

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Saisir votre mot de passe"
            textField.isSecureTextEntry = true
        })
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] action in
            
            //si l'email est au format email, on récupére le password et update
            if ((self.adresseMailTF.text?.isValidEmail) != nil), let password = alert.textFields?.first?.text {
                
                FireAuth().updateUserEmail(newEmail: self.adresseMailTF.text!, password: password)
                self.showAlert("Mise à jour Email", "Un Email de confirmation a été envoyé à votre nouvelle adresse. Consultez votre boite de réception ou courrier indésirable, pour valider le changement d'adresse mail")
                //self.showAlert("Mise a jour", "votre adresse Email est modifiée avec succès")
            }
            }))
        adresseMailTF.resignFirstResponder()
        self.present(alert, animated: true)
        }
    
    func printToConsole(message : String) {
           #if DEBUG
               print(message)
           #endif
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
            //hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
