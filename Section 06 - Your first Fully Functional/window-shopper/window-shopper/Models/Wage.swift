//
//  Wage.swift
//  window-shopper
//
//  Created by Lucas Inocencio on 13/07/20.
//  Copyright © 2020 Lucas Inocencio. All rights reserved.
//

import Foundation

class Wage {
    class func getHours(forWage wage: Double, andPrice price: Double) -> Int {
        return Int(ceil(price / wage))
    }
}
