//
//  MainViewController.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 10/12/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class MainViewController: UIViewController {
    

    
//    @IBOutlet weak var backgroundGif: UIImageView!
//    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var etaView: EtaView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
//    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var animated = false;
    
    
    
    enum EtaStatus: Int {
        case pickup = 100       // Pod is otw to pickup user at their location
        case waiting = 200      // Pod is waiting for user to get inside
        case destination = 300  // Pod is otw to user's final destination
        case arrival = 400      // Pod has arrived to the user's final destination
        case noTicket = 900     // Not Active
        case delayed = 800      // Pod is delayed due to congestion
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ref = FIRDatabase.database().reference()
        let defaults = UserDefaults.standard
        
        if let uid = defaults.value(forKey: "uid") {
            ref.child("users").child(uid as! String).observeSingleEvent(of: .value, with: {(snapshot) in
                let data = snapshot.value as? NSDictionary
                let firstName = data?["firstName"] as? String
                let lastName = data?["lastName"] as? String
                let currentTicket = snapshot.childSnapshot(forPath: "/currentTicket").value as? NSDictionary
                let from = currentTicket?["from"] as? Int
                let to = currentTicket?["to"] as? Int
                let eta = currentTicket?["eta"] as? Int
                let status = currentTicket?["status"] as? Int
                
                self.updateEta(from!, to: to!, eta: eta!, status: status!)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        setupEtaListener()
        
    }
    
    
    func setupEtaListener() {
        let ref = FIRDatabase.database().reference()
        let defualts = UserDefaults.standard
        if let uid = defualts.value(forKey: "uid") {
        print("===========")
        print(uid)
        print("===========")
        let userRef = ref.child("users/\(uid)")
        userRef.observe(.childChanged, with: {(snapshot) in
            let currentTicket = snapshot.value as? [String: AnyObject] ?? [:]
//            print(currentTicket)
            self.updateEta(currentTicket["from"] as! Int,
                           to: currentTicket["to"] as! Int,
                           eta: currentTicket["eta"] as! Int,
                           status:  currentTicket["status"] as! Int)
            })
        }
        
    }
    
    func updateEta(_ from: Int, to: Int, eta: Int, status: Int) {
        
        
        if let etaStatus = EtaStatus(rawValue: status) {
            switch (etaStatus) {
            case .pickup:
                 messageLabel.text = "Your pod is on the way."
                 pickupLabel.text = "Station \(from.description)"
                 destinationLabel.text = "Station \(to.description)"
//                 etaLabel.text = "ETA: \(eta.description)"
//                etaView.centerColor = UIColor.white
                 etaView.gifImage = UIImage.gifImageWithName("pod_moving")!
                 
                 actionButton.setTitle("Enter", for: .normal)
                 actionButton.addTarget(self, action: #selector(enterPod), for: .touchUpInside)
                 actionButton.isEnabled = false
                 actionButton.alpha = 0.0
                if animated {
                    stopAnimation()
                }
            case .waiting:
                messageLabel.text = "Your pod has arrived! \n Please board."
                pickupLabel.text = "Station \(from.description)"
                destinationLabel.text = "Station \(to.description)"
//                etaLabel.text = ""
                etaView.gifImage = UIImage.gifImageWithName("pod_station")!
                if !animated {
                    etaView.centerColor = UIColor.init(red: 0, green: 0.70, blue: 0, alpha: 1.0)
                    animateButton()
                }
                actionButton.setTitle("Enter", for: .normal)
                actionButton.addTarget(self, action: #selector(enterPod), for: .touchUpInside)
                actionButton.isEnabled = true
                actionButton.alpha = 1.0
//                let tap = UITapGestureRecognizer(target: self, action: #selector(enterPod))
//                etaView.addGestureRecognizer(tap)

            case .destination:
                 messageLabel.text = "On our way!"
                 pickupLabel.text = "Station \(from.description)"
                 destinationLabel.text = "Station \(to.description)"
//                 etaLabel.text = "ETA: \(eta.description)"
//                etaView.centerColor = UIColor.white
                 etaView.gifImage = UIImage.gifImageWithName("pod_moving")!
                 
                 actionButton.setTitle("Enter", for: .normal)
                 actionButton.addTarget(self, action: #selector(enterPod), for: .touchUpInside)
                 actionButton.isEnabled = false
                 actionButton.alpha = 0.0
                if animated {
                    stopAnimation()
                }
            case .arrival:
                 messageLabel.text = "Your pod has arrived! \n Please depart."
                 pickupLabel.text = "Station \(from.description)"
                 destinationLabel.text = "Station \(to.description)"
//                 etaLabel.text = ""
                etaView.gifImage = UIImage.gifImageWithName("pod_station")!
                if !animated {
                    etaView.centerColor = UIColor.blue
                    animateButton()
                }
                 
                 actionButton.setTitle("Exit", for: .normal)
                 actionButton.addTarget(self, action: #selector(exitPod), for: .touchUpInside)
                 actionButton.isEnabled = true
                 actionButton.alpha = 1.0
//                let tap = UITapGestureRecognizer(target: self, action: #selector(exitPod))
//                etaView.addGestureRecognizer(tap)
           case .noTicket:
             messageLabel.text = "No Ticket information. \n Purchase Ticket"
             pickupLabel.text = ""
             destinationLabel.text = ""
//             etaLabel.text = ""
                etaView.centerColor = UIColor.white
             etaView.gifImage = UIImage.gifImageWithName("hello")!
                if animated {
                    stopAnimation()
                }
             actionButton.isEnabled = false
             actionButton.alpha = 0.0
            case .delayed:
                 messageLabel.text = "Your pod is delayed! \n Sorry for Inconvenience."
                 pickupLabel.text = "Station \(from.description)"
                 destinationLabel.text = "Station \(to.description)"
//                 etaLabel.text = "ETA: \(eta.description)"
//                etaView.centerColor = UIColor.white
                if !animated{
                    etaView.centerColor = UIColor.red
                    animateButton()
                }
                 actionButton.isEnabled = false
                 actionButton.alpha = 0.0
            }
            
        }
    }
    
    func enterPod() {
        print("Pod Entered")
        
        let user = FIRAuth.auth()?.currentUser
        if let uid = user?.uid {
            let ref = FIRDatabase.database().reference()
            ref.child("users/\(uid)/currentTicket/eta").setValue(10)
            ref.child("users/\(uid)/currentTicket/status").setValue(EtaStatus.destination.rawValue)
        }
//        for recognizer in etaView.gestureRecognizers! {
//            etaView.removeGestureRecognizer(recognizer)
//        }
        
    }
    
    func exitPod() {
        print("Pod Exited")
        
        let user = FIRAuth.auth()?.currentUser
        if let uid = user?.uid {
            let ref = FIRDatabase.database().reference()
            ref.child("users/\(uid)/currentTicket/status").setValue(EtaStatus.noTicket.rawValue)
        }
//        for recognizer in etaView.gestureRecognizers! {
//            etaView.removeGestureRecognizer(recognizer)
//        }
    }
    
    func animateButton() {
        animated = true
        UIView.animate(withDuration: 1.1,
                       delay: 0.1,
                       options: [.curveEaseOut, .repeat, .autoreverse, .allowUserInteraction],
                       animations: changeColor,
                       completion: nil)
    }
    
    func stopAnimation() {
        animated = false
        etaView.layer.removeAllAnimations()
    }
    
    func changeColor() {
        self.etaView.centerColor = self.etaView.centerColor.withAlphaComponent(0.5)
        
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "uid")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController")
                self.present(vc, animated: true, completion: nil)
            } catch let error as Error {
                print(error.localizedDescription)
            }
        }
    }
    
    
}
