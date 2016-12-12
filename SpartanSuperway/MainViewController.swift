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
    @IBOutlet weak var mainButton: UIButton!
    
    var animated = false;
    
    
    enum EtaStatus: Int {
        case etaStatusPickup = 100       // Pod is otw to pickup user at their location
        case etaStatusWaiting = 200      // Pod is waiting for user to get inside
        case etaStatusDestination = 300  // Pod is otw to user's final destination
        case etaStatusArrival = 400      // Pod has arrived to the user's final destination
        case etaStatusNoTicket = 900
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
        
        mainButton.layer.cornerRadius = mainButton.frame.size.height/2
        mainButton.backgroundColor = UIColor.white
        mainButton.layer.borderWidth = 10
        mainButton.layer.borderColor = UIColor(red: 0.04, green: 0.52, blue: 0.85, alpha: 1).cgColor
        mainButton.setTitleColor(UIColor.black, for: .normal)
        mainButton.titleLabel?.lineBreakMode = .byWordWrapping
        mainButton.setTitle("No tickets available", for: .normal)
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
//            print(currentTicket)
            self.updateEta(from: currentTicket["from"] as! String,
                           to: currentTicket["to"] as! String,
                           eta: currentTicket["eta"] as! Int,
                           status:  currentTicket["status"] as! Int)
            })
        }
        
    }
    
    func updateEta(from: String, to: String, eta: Int, status: Int) {
        
        var etaString = "Pickup: \(from)\n" +
            "Destination: \(to)\n\n" +
            "\(status)\n\n" +
            "ETA: \(eta) seconds"
        
        
        if let etaStatus = EtaStatus(rawValue: status) {
            switch (etaStatus) {
            case .etaStatusPickup:
                mainButton.backgroundColor = UIColor.white
                if animated {
                    stopAnimation()
                }
                mainButton.setTitle(etaString, for: .normal)
            case .etaStatusWaiting:
                if !animated {
                    mainButton.backgroundColor = UIColor.init(red: 0, green: 0.70, blue: 0, alpha: 1.0)
                    animateButton()
                }
                mainButton.setTitle("Your pod is here.\n Please board.\n", for: .normal)
                
            case .etaStatusDestination:
                mainButton.backgroundColor = UIColor.white
                if animated {
                    stopAnimation()
                }
                mainButton.setTitle(etaString, for: .normal)
            case .etaStatusArrival:
                if !animated {
                    mainButton.backgroundColor = UIColor.red
                    animateButton()
                }
                mainButton.setTitle("Your pod has arrived at your destination.", for: .normal)
            
            case .etaStatusNoTicket:
                mainButton.backgroundColor = UIColor.white
                if animated {
                    stopAnimation()
                }
                mainButton.setTitle("No Ticket Information", for: .normal)
            }
        }
    }
    
    func animateButton() {
        animated = true
        UIView.animate(withDuration: 1.1, delay: 0.1, options: [.curveEaseOut, .repeat, .autoreverse, .allowUserInteraction], animations: {
            self.mainButton.backgroundColor = self.mainButton.backgroundColor?.withAlphaComponent(0.5)
        }, completion: nil)
    }
    
    func stopAnimation() {
        animated = false
        mainButton.layer.removeAllAnimations()
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
