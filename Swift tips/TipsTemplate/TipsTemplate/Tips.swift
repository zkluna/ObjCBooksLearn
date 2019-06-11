//
//  Tips.swift
//  TipsTemplate
//
//  Created by zl on 2019/6/11.
//  Copyright © 2019 youtil. All rights reserved.
//

import UIKit
import Foundation

/** mutating */
protocol Vehicle {
    var numberOfWheels: Int { get }
    var color: UIColor { get set }
    mutating func changeColor()
}
struct MyCar: Vehicle {
    let numberOfWheels = 4
    var color = UIColor.blue
    mutating func changeColor() {
        color = .red
    }
}
class MyBike: Vehicle {
    let numberOfWheels = 4
    var color = UIColor.white
    func changeColor() {
        color = .red
    }
}
