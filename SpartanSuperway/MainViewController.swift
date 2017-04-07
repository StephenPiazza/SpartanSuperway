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
    
    @IBOutlet weak var purchaseTicketButton: UIButton!
    @IBOutlet weak var viewTicketButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var etaView: EtaView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
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
//        let gradient = CAGradientLayer()
//        gradient.frame = purchaseTicketButton.bounds
//        gradient.cornerRadius = purchaseTicketButton.frame.size.height/2
//        gradient.colors = [UIColor(red: 0.04, green: 0.52, blue: 0.85, alpha: 1).cgColor,
//                           UIColor(red: 0.24, green: 0.62, blue: 0.85, alpha: 1).cgColor,
//                           UIColor(red: 0.04, green: 0.52, blue: 0.85, alpha: 1).cgColor]
//        purchaseTicketButton.layer.insertSublayer(gradient, at: 0)
//        purchaseTicketButton.setImage(UII, for: <#T##UIControlState#>)

        purchaseTicketButton.layer.cornerRadius = purchaseTicketButton.frame.size.height/2
        viewTicketButton.layer.cornerRadius = viewTicketButton.frame.size.height/2
        mapButton.layer.cornerRadius = mapButton.frame.size.height/2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            print(currentTicket)
            self.updateEta(from: currentTicket["from"] as! Int,
                           to: currentTicket["to"] as! Int,
                           eta: currentTicket["eta"] as! Int,
                           status:  currentTicket["status"] as! Int)
            })
        }
        
    }
    
    func updateEta(from: Int, to: Int, eta: Int, status: Int) {
        
        let etaString = "Pickup: \(from)\n" +
            "Destination: \(to)\n\n" +
            "\(status)\n\n" +
            "ETA: \(eta) seconds"
        
        
        if let etaStatus = EtaStatus(rawValue: status) {
            switch (etaStatus) {
            case .pickup:
                etaView.centerColor = UIColor.white
                if animated {
                    stopAnimation()
                }
            case .waiting:
                if !animated {
                    etaView.centerColor = UIColor.init(red: 0, green: 0.70, blue: 0, alpha: 1.0)
                    animateButton()
                }
                let tap = UITapGestureRecognizer(target: self, action: #selector(enterPod))
                etaView.addGestureRecognizer(tap)

            case .destination:
                etaView.centerColor = UIColor.white
                if animated {
                    stopAnimation()
                }
            case .arrival:
                if !animated {
                    etaView.centerColor = UIColor.blue
                    animateButton()
                }
                let tap = UITapGestureRecognizer(target: self, action: #selector(exitPod))
                etaView.addGestureRecognizer(tap)
           case .noTicket:
                etaView.centerColor = UIColor.white
                if animated {
                    stopAnimation()
                }
            case .delayed:
                etaView.centerColor = UIColor.white
                if !animated{
                    etaView.centerColor = UIColor.red
                    animateButton()
                }
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
        for recognizer in etaView.gestureRecognizers! {
            etaView.removeGestureRecognizer(recognizer)
        }
        
    }
    
    func exitPod() {
        print("Pod Exited")
        
        let user = FIRAuth.auth()?.currentUser
        if let uid = user?.uid {
            let ref = FIRDatabase.database().reference()
            ref.child("users/\(uid)/currentTicket/status").setValue(EtaStatus.noTicket.rawValue)
        }
        for recognizer in etaView.gestureRecognizers! {
            etaView.removeGestureRecognizer(recognizer)
        }
    }
    
    func animateButton() {
        animated = true
        UIView.animate(withDuration: 1.1, delay: 0.1, options: [.curveEaseOut, .repeat, .autoreverse, .allowUserInteraction], animations: {
            self.etaView.centerColor = self.etaView.centerColor.withAlphaComponent(0.5)
        }, completion: nil)
    }
    
    func stopAnimation() {
        animated = false
        etaView.layer.removeAllAnimations()
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController")
                self.present(vc, animated: true, completion: nil)
            } catch let error as Error {
                print(error.localizedDescription)
            }
        }
    }

    
    
    
}
