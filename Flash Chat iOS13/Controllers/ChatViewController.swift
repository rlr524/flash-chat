//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Title text
        navigationItem.title = K.appName
        // Hide <Back button
        navigationItem.hidesBackButton = true
    }

    @IBAction func sendPressed(_ sender: UIButton) {
    }
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let e as NSError {
            print("Error signing out: %@", e)
            let alert = UIAlertController(title: "Error",
                                          message: e.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                   comment: "Default action"),
                                          style: .default, handler: { _ in
                NSLog("The \"OK\" alert occurred.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
