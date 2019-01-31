//
//  LoginSignUpViewController.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 1/31/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginSignUpViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    var isloginAction = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            print(auth)
            guard let `self` = self else { return }
            if user == nil {
                //show sign up
                self.loginButton.setTitle("Sign Up", for: .normal)
            } else {
                //show login page
                self.isloginAction = true
                self.titleLabel.text = "Please login to check the poloniex data inside app"
                self.navigateToDataPage()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func validatedFormDetails() -> Bool {
        if let emailText = emailTextField.text, let passWordText = passWordTextField.text {
            if passWordText.isEmpty || emailText.isEmpty {
                let alert = UIAlertController(title: "Error", message: "please fill all details", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //check if the state is login or sign up
        if !isloginAction {
            //sign up api call
            if validatedFormDetails() {
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passWordTextField.text!) { (authResult, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    } else if let user = authResult?.user {
                        UserDefaults.standard.set(user.uid, forKey: "loggedInUserId")
                        //navigate to next page where data is display
                        self.navigateToDataPage()
                    } else {
                        //this condition should not arise
                        print("user object is not present")
                    }
                }
            }
        } else {
            //login api call
        }
    }
    
    func navigateToDataPage() {
        let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
}
