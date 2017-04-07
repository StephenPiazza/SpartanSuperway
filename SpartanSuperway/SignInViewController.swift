//
//  SignInView.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 9/26/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    var tempEmail = "Stephen.apiazza@gmail.com"
    var tempPassword = "password"
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func SignUp(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
//    @IBAction func SignIn(_ sender: AnyObject) {
//        if email.text! == "" || password.text! == "" {
//            //Alert user if no info is filled in
//            let alertController = UIAlertController(title: "Oops!",message: "Please enter an email and password.", preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            self.present(alertController,animated: true, completion: nil)
//        
//        } else {
//            //Using temporary Sign in credentials. Change for release
//            FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: {(user, error) in
//                if error == nil {
//                    //Succesfully logged in
//                     self.performSegue(withIdentifier: "SignInSegue", sender: self)
//                    
//                } else {
//                    //Alert User with the firebase message
//                    let alertController = UIAlertController(title: "Oops!",message: error?.localizedDescription, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController,animated: true, completion: nil)
//                }
//            })
//        }
//    }
    
    @IBAction func SignIn(_ sender: AnyObject) {
            //Using temporary Sign in credentials. Change for release
            FIRAuth.auth()?.signIn(withEmail: tempEmail, password: tempPassword, completion: {(user, error) in
                if error == nil {
                    //Succesfully logged in
                    let uid = user!.uid
                    print(uid)
                    let defaults = UserDefaults.standard
                    defaults.set(uid, forKey: "uid")
                    let mainScreen = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as!UINavigationController
                    self.present(mainScreen, animated: true)
//                    self.performSegue(withIdentifier: "SignInSegue", sender: self)
                    
                } else {
                    //Alert User with the firebase message
                    let alertController = UIAlertController(title: "Oops!",message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController,animated: true, completion: nil)
                }
            })
    }


}
