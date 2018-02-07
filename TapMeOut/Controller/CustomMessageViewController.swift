//
//  CustomMessageViewController.swift
//  TapMeOut
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class CustomMessageViewController: UIViewController {
    
    
    @IBOutlet weak var txtCustomMessage: UITextView!
    weak var delegate: LeftMenuProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.removeNavigationBarItem()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            guard let vc = (self.slideMenuController()?.mainViewController as? UINavigationController)?.topViewController else {
                return
            }
            if vc.isKind(of: CustomMessageViewController.self)  {
                self.slideMenuController()?.removeLeftGestures()
                self.slideMenuController()?.removeRightGestures()
            }
        })
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.changeViewController(LeftMenu.main)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        let userDefaults =  UserDefaults.standard
        userDefaults.set(txtCustomMessage.text, forKey: KUserDefaultMessage)
        userDefaults.synchronize()
        delegate?.changeViewController(LeftMenu.main)

    }

}
