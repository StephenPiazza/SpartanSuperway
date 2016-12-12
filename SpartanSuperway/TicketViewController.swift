//
//  TicketViewController.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 11/18/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController {
    
    var ticket: Ticket?
    
    @IBOutlet weak var locationFrom: UILabel!
    @IBOutlet weak var locationTo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var shareable: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        print(ticket)
        super.viewDidLoad()
        exitButton.layer.cornerRadius = exitButton.frame.size.height/2
        if let tempTicket = self.ticket {
            locationFrom.text = tempTicket.from
            locationTo.text = tempTicket.to
            date.text = tempTicket.date.description
            time.text = tempTicket.time
            shareable.text = tempTicket.shareable.description
        }
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
