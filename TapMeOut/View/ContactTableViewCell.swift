//
//  ContactTableViewCell.swift
//  TapMeOut
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "contactCell"
    static let cellheight:CGFloat = 120.0

    @IBOutlet weak var pofileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    
    @IBOutlet weak var switchLocation: UISwitch!
    
    weak var delegate: ContactTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
    @IBAction func setContractor(_ sender: Any) {
        self.delegate?.setContractor(self, isUseLocation: switchButton.isOn)
        
    }
    
    @IBAction func setLocation(_ sender: Any) {
        self.delegate?.setUseLocationInfo(self, isUseLocation: switchLocation.isOn)
    }
    

    var contactInfo: ContactInfo? {
        didSet {
            if let contactInfo = contactInfo {
                
                nameLabel.text = contactInfo.name
                phoneNumberLabel.text = contactInfo.phoneNumber
                switchButton.setOn(contactInfo.isContractor, animated: true)
                switchLocation.setOn(contactInfo.isUseLocation, animated: true)
                pofileImage.image = contactInfo.profileImage
                
            }
            else {
                switchButton.setOn(false, animated: true)
                nameLabel.text = ""
                phoneNumberLabel.text = ""
            }
        }
    }
}

protocol ContactTableViewCellDelegate: class {
    
    func setUseLocationInfo(_ cell: ContactTableViewCell, isUseLocation newState: Bool)
    func setContractor(_ cell: ContactTableViewCell, isUseLocation newState: Bool)
}
