//
//  CardViewController.swift
//  HelloWorld
//
//  Created by Magiczne on 11/12/2020.
//

import UIKit

class CardViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    func loadImage(image: String) {
        self.image.downloaded(from: image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
