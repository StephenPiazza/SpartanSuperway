//
//  TicketViewController.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 11/18/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController {
    
    enum Station: Int {
        case SJSU = 1
        case SJSUStadium = 2
        case Diridon = 3
        case SantaClara = 4
    }
    
    
    var ticket: Ticket?
    
    @IBOutlet weak var locationFrom: UILabel!
    @IBOutlet weak var locationTo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var shareable: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exitButton.layer.cornerRadius = exitButton.frame.size.height/2
        print("ticket: \(ticket)")
        if let tempTicket = self.ticket {
            print("ticket: \(tempTicket)")
            locationFrom.text = "Station \(String(tempTicket.from))"
            locationTo.text = "Station \(String(tempTicket.to))"
            date.text = tempTicket.date.description
            time.text = tempTicket.time
            shareable.text = tempTicket.shareable.description
        }
    }
    
    override func viewDidLoad() {
        print(ticket)
        super.viewDidLoad()
//        exitButton.layer.cornerRadius = exitButton.frame.size.height/2
//        if let tempTicket = self.ticket {
//            locationFrom.text = String(tempTicket.from)
//            locationTo.text = String(tempTicket.to)
//            date.text = tempTicket.date.description
//            time.text = tempTicket.time
//            shareable.text = tempTicket.shareable.description
//        }
    }
    
    @IBAction func done(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        let parentVc = self.presentingViewController as! UITabBarController
        if parentVc.selectedIndex == 1 {
            print("Parent = Purchase")
            parentVc.selectedIndex = 0

        }
    }
}
