//
//  RountButton.swift
//  StormpathLogin
//
//  Created by Kristaps Kuzmins on 08/02/2017.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit

class RountButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
    }
}
