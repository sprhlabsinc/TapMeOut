//
//  ContactViewController.swift
//  TapMeOut
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import ContactsUI


class ContactViewController: UIViewController {
    
    var contactList:[ContactInfo] = [];
    
    static let sharedManager = ContactViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CONTACTS"
        // Do any additional setup after loading the view.
        contactList = getContacts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.setAddItem()
    }
    
    func setAddItem(){
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = add
    }
    
    func addTapped(){
        let contactVC = CNContactPickerViewController()
        contactVC.delegate = self
        self.present(contactVC, animated:true, completion:nil)
    }
    
    func getContacts()->[ContactInfo]{
        let userDefaults =  UserDefaults.standard
        
        if let decoded = userDefaults.object(forKey: KUserDefaultContactList){
            let decodedContacts = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! [ContactInfo]
            return decodedContacts
        }
        
        return []
    }
    
    func setContacts(contacts: [ContactInfo]){
        let userDefaults =  UserDefaults.standard
        let encodedData:Data = NSKeyedArchiver.archivedData(withRootObject: contacts)
        userDefaults.set(encodedData, forKey: KUserDefaultContactList)
        userDefaults.synchronize()
    }
    
    func fetchSelectedContactList()->[ContactInfo]{
        
        let defauls = UserDefaults.standard
        let phoneList = defauls.array(forKey: KUserDefaultContactList)
        
        let contactStore = CNContactStore()
        let keyToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey] as [Any]
        var allContainers:[CNContainer] = []
        
        do{
            allContainers = try contactStore.containers(matching: nil)
        }catch{
            print("Error fetching containers")
        }
        
        var results:[CNContact] = []
        
        for container in allContainers{
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do{
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keyToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
                
            }catch{
                print("Error fetching results for container")
            }
        }
        
        if phoneList == nil {
            return []
        }
        
        var res:[ContactInfo] = []
        for phone in phoneList!{
            
            for contact in results{
                let phoneNumber = contact.phoneNumbers[0].value.stringValue
                if (phone as! String == phoneNumber) {
                    let fullName = CNContactFormatter.string(from: contact, style: .fullName)
                    
                    var image:UIImage = UIImage(named: "user")!
                    if contact.imageDataAvailable {
                        image = UIImage(data: contact.imageData!)!
                    }
                    let contactInfo = ContactInfo(name: fullName!, phoneNumber: phoneNumber, profileImage: image, isUseLocation: true, isContractor:true)
                    res.append(contactInfo)
                    break
                }

            }
        }
        
        return res;
        
    }
    
    func isExistContact(number:String)->Bool{
        for contact in contactList{
            if contact.phoneNumber == number {
                return true
            }
        }
        return false
    }
    
    func getCountryPhonceCode (countryCode : String) -> String
    {
        
        let country = countryCode.uppercased()
        if country.length == 2
        {
            let x : [String] = ["972", "IL",
                                "93" , "AF",
                                "355", "AL",
                                "213", "DZ",
                                "1"  , "AS",
                                "376", "AD",
                                "244", "AO",
                                "1"  , "AI",
                                "1"  , "AG",
                                "54" , "AR",
                                "374", "AM",
                                "297", "AW",
                                "61" , "AU",
                                "43" , "AT",
                                "994", "AZ",
                                "1"  , "BS",
                                "973", "BH",
                                "880", "BD",
                                "1"  , "BB",
                                "375", "BY",
                                "32" , "BE",
                                "501", "BZ",
                                "229", "BJ",
                                "1"  , "BM",
                                "975", "BT",
                                "387", "BA",
                                "267", "BW",
                                "55" , "BR",
                                "246", "IO",
                                "359", "BG",
                                "226", "BF",
                                "257", "BI",
                                "855", "KH",
                                "237", "CM",
                                "1"  , "CA",
                                "238", "CV",
                                "345", "KY",
                                "236", "CF",
                                "235", "TD",
                                "56", "CL",
                                "86", "CN",
                                "61", "CX",
                                "57", "CO",
                                "269", "KM",
                                "242", "CG",
                                "682", "CK",
                                "506", "CR",
                                "385", "HR",
                                "53" , "CU" ,
                                "537", "CY",
                                "420", "CZ",
                                "45" , "DK" ,
                                "253", "DJ",
                                "1"  , "DM",
                                "1"  , "DO",
                                "593", "EC",
                                "20" , "EG" ,
                                "503", "SV",
                                "240", "GQ",
                                "291", "ER",
                                "372", "EE",
                                "251", "ET",
                                "298", "FO",
                                "679", "FJ",
                                "358", "FI",
                                "33" , "FR",
                                "594", "GF",
                                "689", "PF",
                                "241", "GA",
                                "220", "GM",
                                "995", "GE",
                                "49" , "DE",
                                "233", "GH",
                                "350", "GI",
                                "30" , "GR",
                                "299", "GL",
                                "1"  , "GD",
                                "590", "GP",
                                "1"  , "GU",
                                "502", "GT",
                                "224", "GN",
                                "245", "GW",
                                "595", "GY",
                                "509", "HT",
                                "504", "HN",
                                "36" , "HU",
                                "354", "IS",
                                "91" , "IN",
                                "62" , "ID",
                                "964", "IQ",
                                "353", "IE",
                                "972", "IL",
                                "39" , "IT",
                                "1"  , "JM",
                                "81", "JP", "962", "JO", "77", "KZ",
                                "254", "KE", "686", "KI", "965", "KW", "996", "KG",
                                "371", "LV", "961", "LB", "266", "LS", "231", "LR",
                                "423", "LI", "370", "LT", "352", "LU", "261", "MG",
                                "265", "MW", "60", "MY", "960", "MV", "223", "ML",
                                "356", "MT", "692", "MH", "596", "MQ", "222", "MR",
                                "230", "MU", "262", "YT", "52","MX", "377", "MC",
                                "976", "MN", "382", "ME", "1", "MS", "212", "MA",
                                "95", "MM", "264", "NA", "674", "NR", "977", "NP",
                                "31", "NL", "599", "AN", "687", "NC", "64", "NZ",
                                "505", "NI", "227", "NE", "234", "NG", "683", "NU",
                                "672", "NF", "1", "MP", "47", "NO", "968", "OM",
                                "92", "PK", "680", "PW", "507", "PA", "675", "PG",
                                "595", "PY", "51", "PE", "63", "PH", "48", "PL",
                                "351", "PT", "1", "PR", "974", "QA", "40", "RO",
                                "250", "RW", "685", "WS", "378", "SM", "966", "SA",
                                "221", "SN", "381", "RS", "248", "SC", "232", "SL",
                                "65", "SG", "421", "SK", "386", "SI", "677", "SB",
                                "27", "ZA", "500", "GS", "34", "ES", "94", "LK",
                                "249", "SD", "597", "SR", "268", "SZ", "46", "SE",
                                "41", "CH", "992", "TJ", "66", "TH", "228", "TG",
                                "690", "TK", "676", "TO", "1", "TT", "216", "TN",
                                "90", "TR", "993", "TM", "1", "TC", "688", "TV",
                                "256", "UG", "380", "UA", "971", "AE", "44", "GB",
                                "1", "US", "598", "UY", "998", "UZ", "678", "VU",
                                "681", "WF", "967", "YE", "260", "ZM", "263", "ZW",
                                "591", "BO", "673", "BN", "61", "CC", "243", "CD",
                                "225", "CI", "500", "FK", "44", "GG", "379", "VA",
                                "852", "HK", "98", "IR", "44", "IM", "44", "JE",
                                "850", "KP", "82", "KR", "856", "LA", "218", "LY",
                                "853", "MO", "389", "MK", "691", "FM", "373", "MD",
                                "258", "MZ", "970", "PS", "872", "PN", "262", "RE",
                                "7", "RU", "590", "BL", "290", "SH", "1", "KN",
                                "1", "LC", "590", "MF", "508", "PM", "1", "VC",
                                "239", "ST", "252", "SO", "47", "SJ",
                                "963","SY",
                                "886",
                                "TW", "255",
                                "TZ", "670",
                                "TL","58",
                                "VE","84",
                                "VN",
                                "284", "VG",
                                "340", "VI",
                                "678","VU",
                                "681","WF",
                                "685","WS",
                                "967","YE",
                                "262","YT",
                                "27","ZA",
                                "260","ZM",
                                "263","ZW"]
            var keys = [String]()
            var values = [String]()
            let whitespace = NSCharacterSet.decimalDigits
            
            //let range = phrase.rangeOfCharacterFromSet(whitespace)
            for i in x {
                // range will be nil if no whitespace is found
                if  (i.rangeOfCharacter(from: whitespace) != nil) {
                    values.append(i)
                }
                else {
                    keys.append(i)
                }
            }
            let countryCodeListDict = NSDictionary(objects: values as [String], forKeys: keys as [String] as [NSCopying]) 
            if let _: AnyObject = countryCodeListDict.value(forKey: country) as AnyObject? {
                return countryCodeListDict[country] as! String
            } else
            {
                return ""
            }
        }
        else
        {
            return ""
        }
    }

}
extension ContactViewController: CNContactPickerDelegate{
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        var temp:[ContactInfo] = []
        
        var nCount = 0
        for contact in contacts{
            let fullName = CNContactFormatter.string(from: contact, style: .fullName)
            let numberValue = contact.phoneNumbers[0].value
            
            let countryCode = numberValue.value(forKey: "countryCode") as? String
            let digits = numberValue.value(forKey: "digits") as? String
            
            let phoneNumber = "+"+getCountryPhonceCode(countryCode: countryCode!) + digits!

            
 //           if isExistContact(number: phoneNumber) {
 //               continue
 //           }
            var image:UIImage = UIImage(named: "user")!
            if contact.imageDataAvailable {
                image = UIImage(data: contact.imageData!)!
            }
            let contactInfo = ContactInfo(name: fullName!, phoneNumber: phoneNumber, profileImage: image, isUseLocation: true, isContractor:true)
            temp.append(contactInfo)
            nCount += 1
            if nCount == 3 {
                break
            }
        }
        contactList = temp
        
        // Save ContactList on Local
        var phonelist:[String] = []
        for contact in contactList{
            phonelist.append(contact.phoneNumber)
        }
       
        setContacts(contacts: contactList)
        self.tableView.reloadData()
    }
    

}
extension ContactViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactTableViewCell.cellheight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension ContactViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier, for: indexPath)
        
        let contactInfo = contactList[indexPath.row]
        
        if let cell = cell as? ContactTableViewCell {
            cell.contactInfo = contactInfo
            cell.delegate = self
        }
        
        return cell
    }
    
    
}

extension ContactViewController : ContactTableViewCellDelegate{
    func setUseLocationInfo(_ cell: ContactTableViewCell, isUseLocation newState: Bool) {
        cell.contactInfo?.isUseLocation = newState
        self.setContacts(contacts: self.contactList)
        
    }
    func setContractor(_ cell: ContactTableViewCell, isUseLocation newState: Bool) {
        cell.contactInfo?.isContractor = newState
        self.setContacts(contacts: self.contactList)
    }
}
