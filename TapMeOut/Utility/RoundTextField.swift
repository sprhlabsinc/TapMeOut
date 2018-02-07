//
//  RoundTextField.swift
//  StormpathLogin
//
//  Created by Kristaps Kuzmins on 08/02/2017.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit

class RoundTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let padding = UIEdgeInsets(top: 2, left: 20, bottom: 2, right: 20)
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        self.font = UIFont.boldSystemFont(ofSize: 20)
        
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
