//
//  MenuViewController.swift
//  TapMeOut
//
//  Created by mac on 3/16/17.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case catact
    case custom
    case logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class MenuViewController: UIViewController , LeftMenuProtocol{

    @IBOutlet weak var tableView: UITableView!
    var menus = ["Main", "Contacts", "Customize Message","Logout"]
    var mainViewController: UIViewController!
    var contactViewController: UIViewController!
    var customViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactViewController = storyboard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.contactViewController = UINavigationController(rootViewController: contactViewController)
        
        let customViewController = storyboard.instantiateViewController(withIdentifier: "CustomViewController") as! CustomMessageViewController
        self.customViewController = UINavigationController(rootViewController: customViewController)
        customViewController.delegate = self
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .catact:
            self.slideMenuController()?.changeMainViewController(self.contactViewController, close: true)
        case .logout:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.logout()
        case .custom:
            self.slideMenuController()?.changeMainViewController(self.customViewController, close: true)
        }
   

    }

}
extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .catact, .logout, .custom:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension MenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .catact, .logout,.custom:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
