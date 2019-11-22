//
//  Shape.swift
//  LIFE-SHARE
//
//  Created by baby1234 on 29/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

final class Round8View: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 8
    }
}

final class RoundView: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = frame.width / 2
    }
}

final class HeightRoundButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = frame.height / 2
    }
}

final class BorderAndRoundButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 3
        layer.borderColor = Color.main.cgColor
    }
}

final class BorderAndRound10View: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
    }
}

final class Round8TextView: UITextView {
    override func awakeFromNib() {
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 8
    }
}
