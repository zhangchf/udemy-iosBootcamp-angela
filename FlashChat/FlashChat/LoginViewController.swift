//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Chaofan Zhang on 26/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.tag = 0
        emailTextField.returnKeyType = UIReturnKeyType.continue
        passwordTextField.tag = 1
        passwordTextField.returnKeyType = UIReturnKeyType.go
        
        loginButton.isEnabled = false

        // Do any additional setup after loading the view.
        navigationItem.title = "Login"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func onLoginPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "Log in failed")
                print("login failed", error.debugDescription)
            } else {
                SVProgressHUD.dismiss()
                print("login succeed", user)
                self.performSegue(withIdentifier: "loginSucceed", sender: self)
            }
        }
    }
    
    @IBAction func onValueChanged(_ sender: UITextField) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.count > 5, password.count > 3 {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
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
