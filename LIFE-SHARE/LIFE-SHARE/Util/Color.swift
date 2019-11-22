//
//  Color.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 03/09/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

struct Color {
    static let main = UIColor().hexStringToUIColor(hex: "E5C80B")
    static let main2 = UIColor().hexStringToUIColor(hex: "E5980B")
    static let reject = UIColor().hexStringToUIColor(hex: "FE0100")
    static let accept = UIColor().hexStringToUIColor(hex: "02B150")

}

extension UIColor {
    func hexStringToUIColor (hex:String) -> UIColor {
        let cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
