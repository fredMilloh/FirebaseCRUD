//
//  ImageLoader.swift
//  FirebaseCRUD
//
//  Created by fred on 20/02/2021.
//

import UIKit
import SDWebImage

class ImageLoader {
    
    func loadImage(_ string: String?, _ view: UIImageView) {
        guard let stringUrl = string else { return }
        guard let url = URL(string: stringUrl) else { return }
        view.sd_setImage(with: url, completed: nil)
    }
    
}
