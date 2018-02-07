//
//  ContactInfo.swift
//  TapMeOut
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit

class ContactInfo:NSObject, NSCoding {
    /// The name of the Asset.
    let name: String
    
    /// The AVURLAsset corresponding to this Asset.
    let phoneNumber: String
    
    // Profile Photo
    let profileImage:UIImage
    
    // Does Use Geo Location
    var isUseLocation:Bool
    
    // Does Use Geo Location
    var isContractor:Bool
    
    init(name:String, phoneNumber:String, profileImage:UIImage, isUseLocation:Bool, isContractor:Bool) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
        self.isUseLocation = isUseLocation
        self.isContractor = isContractor
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name")
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber")
        let profileImage = aDecoder.decodeObject(forKey: "profileImage")
        let isUseLocation = aDecoder.decodeBool(forKey: "isUseLocation")
        let isContractor = aDecoder.decodeBool(forKey: "isContractor")
        self.init(name:name as! String,phoneNumber:phoneNumber as! String,profileImage:profileImage as! UIImage,isUseLocation:isUseLocation, isContractor:isContractor)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey:"name")
        aCoder.encode(phoneNumber,forKey:"phoneNumber")
        aCoder.encode(profileImage,forKey:"profileImage")
        aCoder.encode(isUseLocation,forKey:"isUseLocation")
        aCoder.encode(isContractor,forKey:"isContractor")
    }

}
