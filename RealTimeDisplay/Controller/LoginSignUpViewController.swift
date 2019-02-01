//
//  LoginSignUpViewController.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 1/31/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class LoginSignUpViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Exchange Trade Info"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let `self` = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            if user != nil {
                self.navigateToDataPage()
            }
            Auth.auth().removeStateDidChangeListener(self.handle!)
        }
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
        //sign up api call
        if validatedFormDetails() {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passWordTextField.text!) { [weak self] (authResult, error) in
                guard let `self` = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    if error?._code == 17007 {
                        alert.title = "Alert"
                        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passWordTextField.text!, completion: {[weak self] (auth, error) in
                                guard let `self` = self else { return }
                                MBProgressHUD.hide(for: self.view, animated: true)
                                if let user = auth?.user {
                                    UserDefaults.standard.set(user.uid, forKey: "loggedInUserId")
                                    //navigate to next page where data is display
                                    self.navigateToDataPage()
                                } else {
                                    print("error in \(String(describing: error?.localizedDescription))")
                                }
                            })
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    } else {
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    }
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
    }
    
    func navigateToDataPage() {
        let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataDisplayViewController")
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
}
