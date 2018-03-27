//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Chaofan Zhang on 26/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
import SVProgressHUD

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let NODE_MESSAGE = "Messages"

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!

    let messagesDB = Database.database().reference().child("Messages")
    var messages = [Message]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageTextField.delegate = self
        sendButton.isEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onUserTap))
        chatTableView.addGestureRecognizer(tapGestureRecognizer)
        
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "chatTableViewCell")
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 44
        chatTableView.separatorStyle = .none
        
        loadMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - keyboard
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print("keyboardWillShow, keyboardHeight \(keyboardHeight)")
            if messageContainerHeightConstraint.constant < keyboardHeight {
                UIView.animate(withDuration: 3, animations: {
                    self.messageContainerHeightConstraint.constant += keyboardHeight
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print("keyboardWillHide, keyboardHeight \(keyboardHeight)")
            if messageContainerHeightConstraint.constant > keyboardHeight {
                UIView.animate(withDuration: 3, animations: {
                    self.messageContainerHeightConstraint.constant -= keyboardHeight
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if let msg = textField.text, msg.count > 0 {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
        return true
    }
    
    @objc func onUserTap() {
        messageTextField.endEditing(true)
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell", for: indexPath) as! ChatTableViewCell
        let msg = messages[indexPath.row]
        cell.senderAvatar.image = #imageLiteral(resourceName: "egg")
        cell.senderLabel.text = msg.sender
        cell.messageLabel.text = msg.message
        return cell
    }
    
    //MARK: - LoadData
    func loadMessages() {
        print("loadMessages")
        messagesDB.observe(DataEventType.childAdded) { (dataSnapshot) in
            let postDic = dataSnapshot.value as! [String : String]
            print("childAdded", postDic)
            self.messages.append(Message(sender: postDic["sender"]!, message: postDic["message"]!))
            self.chatTableView.reloadData()
        }
    }
    
    @IBAction func onSendClicked(_ sender: Any) {
        var data = [String : String]()
        data["sender"] = Auth.auth().currentUser?.email
        data["message"] = messageTextField.text
        print("send message", data)
        SVProgressHUD.show()
        messagesDB.childByAutoId().setValue(data) { (error, dbRef) in
            if error != nil {
                print("send message failed", error.debugDescription)
                SVProgressHUD.showError(withStatus: "Send Message Failed")
            } else {
                SVProgressHUD.dismiss()
                print("send message succeed")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
