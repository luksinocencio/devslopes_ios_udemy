//
//  BorderButton.swift
//  app-swoosh
//
//  Created by Lucas Inocencio on 24/06/20.
//  Copyright © 2020 Lucas Inocencio. All rights reserved.
//

import UIKit

class BorderButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
    }

}
