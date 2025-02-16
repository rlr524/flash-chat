//
//  RegisterViewController.swift
//  Flash Chat iOS13
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let e = error {
                    // Log the error and present it to the user
                    print(e)
                        let alert = UIAlertController(title: "Error",
                                                  message: e.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                           comment: "Default action"),
                                                  style: .default, handler: {_ in
                        NSLog("The \"OK\" alert occurred.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Navigate to the ChatViewController
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
}
