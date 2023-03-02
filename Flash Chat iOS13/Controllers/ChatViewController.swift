//
//  ChatViewController.swift
//  Flash Chat iOS13
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.delegate = self
        tableView.dataSource = self
        // Title text
        navigationItem.title = K.appName
        // Hide <Back button
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil),
                           forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName).addSnapshotListener { querySnapshot, error in
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapShotDocuments = querySnapshot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e.localizedDescription)")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
        messageTextfield.text = ""
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

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,
                                                 for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
}

// Use this if we want the user to be able to interact with individual rows
// extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
// }
