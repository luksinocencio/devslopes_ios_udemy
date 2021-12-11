//
//  Category.swift
//  coder-swag
//
//  Created by Lucas Inocencio on 26/07/20.
//  Copyright © 2020 Lucas Inocencio. All rights reserved.
//

import Foundation

struct Category {
    private(set) public var title: String
    private(set) public var imageName: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
