//
//  SignUpViewController.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 9/28/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBAction func signUp(_ sender: AnyObject) {
        if validateUserInformation() {
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if error == nil {
                    var uid = FIRAuth.auth()?.currentUser?.uid
                    var ref = FIRDatabase.database().reference()
                    
                    ref = ref.child("users").child(uid!)
                    ref.child("firstName").setValue(self.firstName.text)
                    ref.child("lastName").setValue(self.lastName.text)
                    ref.child("currentTicket").child("isNewTicket").setValue(false)
                    ref.child("currentTicket").child("to").setValue(1)
                    ref.child("currentTicket").child("from").setValue(1)
                    ref.child("currentTicket").child("eta").setValue(0)
                    ref.child("currentTicket").child("status").setValue(900)
                    ref.child("currentTicket").child("timerOn").setValue(false)
                    
                    let defaults = UserDefaults.standard
                    defaults.set(uid, forKey: "uid")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true,completion: nil)
                    
                }
            })
        }
        else {
            let alertController = UIAlertController(title: "Oops", message: "All fields must be filled out correctly", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true,completion: nil)
            
        }
    }
    
    func validateUserInformation() -> Bool {
        return isValidEmail() && passwordsMatch()
    }
    
    func passwordsMatch() -> Bool {
        return password.text! == confirmPassword.text!
    }
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTester = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTester.evaluate(with: email.text!);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing((true))
        super.touchesBegan(touches, with: event)
    }
    

}
