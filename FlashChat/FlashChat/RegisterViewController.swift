//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by Chaofan Zhang on 26/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.tag = 0
        emailTextField.returnKeyType = UIReturnKeyType.next
        passwordTextField.tag = 1
        passwordTextField.returnKeyType = UIReturnKeyType.go

        // Do any additional setup after loading the view.
        navigationItem.title = "Register"
        
        registerButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickRegisterButton(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "Register failed")
                print("Create user failed", error.debugDescription)
            } else {
                print("Create user succeed:", user!)
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "registerSucceed", sender: self)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.count > 5, password.count > 3 {
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func onValueChanged(_ sender: UITextField) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.count > 5, password.count > 3 {
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
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
