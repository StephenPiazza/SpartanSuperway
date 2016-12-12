//
//  TicketTableViewCell.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 12/4/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var stationFrom: UILabel!
    @IBOutlet weak var stationTo: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
