//
//  ViewController.swift
//  XYZ
//
//  Created by Lucas Inocencio on 27/07/20.
//  Copyright © 2020 Lucas Inocencio. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
  // MARK: - Variables
  var motionManager: CMMotionManager!
  
  // MARK: - IBOutlet
  @IBOutlet weak var xLabel: UILabel!
  @IBOutlet weak var yLabel: UILabel!
  @IBOutlet weak var zLabel: UILabel!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    motionManager = CMMotionManager()
    motionManager.startAccelerometerUpdates(to: .main, withHandler: updateLabels)
  }
  
  // MARK: - Methods
  func updateLabels(data: CMAccelerometerData?, error: Error?) {
    guard let accelerometerData = data else { return }
    
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    
    let x = formatter.string(for: accelerometerData.acceleration.x)!
    let y = formatter.string(for: accelerometerData.acceleration.y)!
    let z = formatter.string(for: accelerometerData.acceleration.z)!
    
    xLabel.text = "X: \(x)"
    yLabel.text = "Y: \(y)"
    zLabel.text = "Z: \(z)"
  }
  
}

