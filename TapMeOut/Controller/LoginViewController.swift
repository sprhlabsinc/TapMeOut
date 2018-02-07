//
//  LoginViewController.swift
//  StormpathLogin
//
//  Created by Mac on 08/02/2017.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire


class LoginViewController: UIViewController{

    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var viewSignin: UIView!
    @IBOutlet weak var viewSignup: UIView!
    
    @IBOutlet weak var txtSignupEmail: RoundTextField!
    @IBOutlet weak var txtSignupPassword: RoundTextField!
    @IBOutlet weak var txtSignupConfirm: RoundTextField!

    
    @IBOutlet weak var btnSignupCheck: UIButton!
    
    
    //SignIn Page Setting
    
    @IBOutlet weak var txtSigninEmail: RoundTextField!
    @IBOutlet weak var txtSigninPassword: RoundTextField!
    
    @IBOutlet weak var btnSigninCheck: UIButton!
    
    @IBOutlet var tapGesture:UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSignup.isHidden = true
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        let isKeepSign = defaults.string(forKey: KUserDefaultKeepSign)
        let loginStatus = defaults.bool(forKey: KUserDefaultLogin)
        
        if(isKeepSign == "yes"){
            btnSigninCheck.isSelected = true
            if loginStatus {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.createMenuView()
            }

        }else if(isKeepSign == nil){
            btnSigninCheck.isSelected = true;
            defaults.set("yes", forKey: KUserDefaultKeepSign)
            defaults.synchronize()
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        self.txtSigninEmail.becomeFirstResponder()
        self.txtSigninPassword.resignFirstResponder()
        self.txtSignupEmail.becomeFirstResponder()
        self.txtSignupConfirm.becomeFirstResponder()
        self.txtSignupPassword.resignFirstResponder()
    }

    @IBAction func tapSignin(_ sender: Any) {
        btnSignin.isSelected = true
        btnSignup.isSelected = false
        viewSignin.isHidden = false
        viewSignin.isUserInteractionEnabled = true
        viewSignup.isHidden = true
        viewSignup.isUserInteractionEnabled = false
    }
    @IBAction func tapSignup(_ sender: Any) {
        btnSignin.isSelected = false
        btnSignup.isSelected = true
        viewSignin.isHidden = true
        viewSignup.isHidden = false
        viewSignin.isUserInteractionEnabled = false
        viewSignup.isUserInteractionEnabled = true
    }
    
    
    @IBAction func tapSigninCheck(_ sender: Any) {
        
        if btnSigninCheck.isSelected {
            btnSigninCheck.isSelected = false
        }else{
            btnSigninCheck.isSelected = true
        }
        // keep login
        let isKeep = btnSigninCheck.isSelected ? "yes":"no"
        let defaults = UserDefaults.standard
        defaults.set(isKeep, forKey: KUserDefaultKeepSign)
        defaults.synchronize()
    }
    
    //SignIn
    @IBAction func signin(_ sender: Any) {
        
        let password = txtSigninPassword.text!
        let email = txtSigninEmail.text!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [ "username": email , "password":password ]
        
        NetworkManager.sharedClient.postRequest(tag: "command=login", parameters: params as NSDictionary) { (error, result) in
                MBProgressHUD.hide(for: self.view, animated: true);
                if (error != "") {
                    self.showAlert(withTitle: "Error", message: error)
                }
                else{
                    
                    let id = (result as! [NSDictionary])[0].value(forKey: "id") as! String
                    
                    let userDefaults = UserDefaults.standard
                    
                    userDefaults.setValue(id, forKey: "id")
                    userDefaults.setValue(email, forKey: "email")
                    userDefaults.setValue(password , forKey: "password")
                    userDefaults.setValue(true, forKey: "loggedin")
                    userDefaults.synchronize()

                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.createMenuView()
       
                }
        }

    }
    // ================SignUp  Page =================
    
    @IBAction func tapSignupCheck(_ sender: Any) {
        if btnSignupCheck.isSelected {
            btnSignupCheck.isSelected = false
        }else{
            btnSignupCheck.isSelected = true
        }
    }
    @IBAction func signUp(_ sender: Any) {
        let password = txtSignupPassword.text!
        let confirm = txtSignupConfirm.text!
        let email = txtSignupEmail.text!
        
        if(password != confirm){
           self.showAlert(withTitle: "Warning!", message: "Password confirmation doesn't match Password.")
            txtSignupPassword.text = ""
            txtSignupConfirm.text = ""
            return
        }
       
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [ "username": email , "password":password, "pushid":"devicetoken", "devicetype": "iphone" ]
        
        NetworkManager.sharedClient.postRequest(tag: "command=usersignupios", parameters: params as NSDictionary) { (error, result) in
            MBProgressHUD.hide(for: self.view, animated: true);
            if (error != "") {
                self.showAlert(withTitle: "Error", message: error)
            }
            else{
                
                
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(email, forKey: "email")
                userDefaults.setValue(password , forKey: "password")
                userDefaults.setValue(true, forKey: "loggedin")
                userDefaults.synchronize()
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.createMenuView()
                
            }
        }
        
    }
    
    func exit() {
        dismiss(animated: true, completion: nil)
    }
 
}

extension LoginViewController:UITextFieldDelegate{
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1;
        // Try to find next responder
        if(textField == self.txtSigninPassword || textField == self.txtSignupConfirm){
            textField.resignFirstResponder()
        }else if let nextResponder:UIResponder = textField.superview!.viewWithTag(nextTag) {
            // Found next responder, so set it.
            nextResponder.becomeFirstResponder();
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return false; // We do not want UITextField to insert line-breaks.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setViewMovedUp(up: true, view: self.view, offset: 30)
        self.view.addGestureRecognizer(self.tapGesture!)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setViewMovedUp(up: false, view: self.view, offset: 30)
        self.view.removeGestureRecognizer(self.tapGesture!)
    }
}

// Helper extension to display alerts easily.
extension UIViewController {
    func showAlert(withTitle title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setViewMovedUp(up movedUp:Bool, view content:UIView, offset xOffset:CGFloat){
        UIView.animate(withDuration: 0.3) { 
            var rect:CGRect = content.frame
            if(movedUp){
                rect.origin.y -= xOffset
            }else{
                rect.origin.y += xOffset
            }
            content.frame = rect
        }
    }

}
