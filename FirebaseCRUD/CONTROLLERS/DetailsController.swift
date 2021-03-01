//
//  DetailsController.swift
//  FirebaseCRUD
//
//  Created by fred on 01/03/2021.
//

import UIKit

class DetailsController: UIViewController {

    @IBOutlet weak var titreLb: UILabel!
    @IBOutlet weak var partLb: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var pitchTV: UITextView!
    @IBOutlet weak var yearLb: UILabel!
    @IBOutlet weak var directorLb: UILabel!
    
    var movieSelected: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    func update() {
        titreLb.text = movieSelected.titre
        partLb.text = movieSelected.part
        pitchTV.text = movieSelected.pitch
        yearLb.text = movieSelected.year
        directorLb.text = movieSelected.director
        ImageLoader().loadImage(self.movieSelected.movieImageUrl, self.imageMovie)
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
