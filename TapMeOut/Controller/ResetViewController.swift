//
//  ResetViewController.swift
//  StormpathLogin
//
//  Created by Mac on 08/02/2017.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit
import MBProgressHUD

class ResetViewController: UIViewController {

    @IBOutlet weak var txtEmail: RoundTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func reset(_ sender: Any) {
        
//            if (error != nil) {
//                self.showAlert(withTitle: "Email", message: "Email doesn't exists in our database")
//            }else{
//                self.showAlert(withTitle: "Password email", message: "Please check your email for resetting the password")
//            }

        let email = txtEmail.text!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [ "username": email]
        
        NetworkManager.sharedClient.postRequest(tag: "command=resetpassword", parameters: params as NSDictionary) { (error, result) in
            MBProgressHUD.hide(for: self.view, animated: true);
            if (error != "") {
                self.showAlert(withTitle: "Error", message: error)
            }
            else{
               self.showAlert(withTitle: "Password email", message: "Please check your email for resetting the password")
            }
        }

    }
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func tap(gesture: UITapGestureRecognizer) {
        self.txtEmail.resignFirstResponder()
    }
}
