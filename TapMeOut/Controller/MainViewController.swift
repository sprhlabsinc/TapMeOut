//
//  MainViewController.swift
//  TapMeOut
//
//  Created by mac on 3/16/17.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import CRNetworkButton
import CoreLocation
import StoreKit

class MainViewController: UIViewController {

    var locationManager: CLLocationManager!
    
    var products = [SKProduct]()
    
    @IBOutlet weak var btnTap: CRNetworkButton!
    
    @IBOutlet weak var lblTap: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TAP ME OUT"
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        
        
        let image = UIImage(named: "double")?.withRenderingMode(.alwaysTemplate)
        btnTap.setBackgroundImage(image, for: .normal)
        btnTap.tintColor = KBasicColor
        lblTap.isHidden = true;
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: KUserDefaultLogin)
        defaults.synchronize()
        
    }
  

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendSMS(_ sender: CRNetworkButton) {

        let contactList = ContactViewController.sharedManager.getContacts()
        var phone:[String] = []
        var messages:[String] = []
        var location:[Any] = []
        

        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        let loc = "\(locValue.latitude),\(locValue.longitude)"
        print("locations = \(locValue.latitude),\(locValue.longitude)")
        
        let userDefaults =  UserDefaults.standard
        var message = userDefaults.string(forKey: KUserDefaultMessage)
        message = message == nil ? "Hey  'Name'.  please call me and check on me. I may be in trouble or need help" : message
        for contact in contactList{
            if contact.isContractor {
                phone.append(contact.phoneNumber)
                let temp = message?.replacingOccurrences(of: "'Name'", with: contact.name)
                messages.append(temp!)
                if contact.isUseLocation {
                    location.append(loc)
                }else{
                    location.append("")
                }
            }
        }

        let params = [ "phone": phone,"location":location,"message":messages ]
        
//        self.btnTap.tintColor = UIColor.blue
//        self.btnTap.setTitleColor(UIColor.blue, for: UIControlState.normal)
//        self.btnTap.isEnabled = false
        self.btnTap.setBackgroundImage(nil, for: .normal)
        self.lblTap.isHidden = false;
        
        NetworkManager.sharedClient.postRequest(tag: "command=sms", parameters: params as NSDictionary) { (error, result) in
            if (error != "") {
                sender.stopByError()
                let image = UIImage(named: "double")?.withRenderingMode(.alwaysTemplate)
                self.btnTap.setBackgroundImage(image, for: .normal)
                self.btnTap.tintColor = KBasicColor
                self.lblTap.isHidden = true;
            }else{
                //sender.stopAnimate()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 30) {
                    let image = UIImage(named: "double")?.withRenderingMode(.alwaysTemplate)
                    self.btnTap.setBackgroundImage(image, for: .normal)
                    self.btnTap.tintColor = KBasicColor
                    self.lblTap.isHidden = true;
                    self.btnTap.stopAnimate()
                }
            }
        }
    }

    
    @IBAction func tapButton(_ sender: CRNetworkButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2*NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            sender.stopAnimate()
        }
    }
    @IBAction func buyInApp(_ sender: Any) {
        
        if(products.count == 0) {return}
        let product = products[0]
        TapMeProducts.store.buyProduct(product)
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (_, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
        }
    }
    func reload() {
        products = []
        
        TapMeProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
    }

}

extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

extension MainViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

