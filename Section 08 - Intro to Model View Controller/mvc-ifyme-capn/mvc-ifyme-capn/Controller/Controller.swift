//
//  Controller.swift
//  mvc-ifyme-capn
//
//  Created by Lucas Inocencio on 26/07/20.
//  Copyright © 2020 Lucas Inocencio. All rights reserved.
//

import UIKit

class Controller: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var iphoneNameLabel: UILabel!
    @IBOutlet weak var iphoneColorLabel: UILabel!
    @IBOutlet weak var iphonePriceLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appleProduct = AppleProduct(name: "iPhone X", color: "Space Gray", price: 999.99)
        iphoneNameLabel.text = appleProduct.name
        iphoneColorLabel.text = "in \(appleProduct.color)"
        iphonePriceLabel.text = "$\(appleProduct.price)"
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 21))
        label.center = CGPoint(x: view.frame.width / 2, y: 185)
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 22)
        label.text = "My dream in this year"
        self.view.addSubview(label)
    }
    
    @IBAction func handleChange(_ sender: Any) {
        let appleProduct = SamsungProduct(name: "Samsung S8", color: "Blue", price: 799.99)
        
        iphoneNameLabel.text = appleProduct.name
        iphoneColorLabel.text = "in \(appleProduct.color)"
        iphonePriceLabel.text = "$\(appleProduct.price)"
    }
}

