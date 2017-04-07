//
//  Ticket.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 11/18/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import Foundation

class Ticket {
    
    let from: Int
    let to: Int
    let date: Date
    let time: String
    let shareable: Bool
    
    init(from: Int, to: Int, date: Date, time: String, shareable: Bool) {
        self.from = from
        self.to = to
        self.date = date
        self.time = time
        self.shareable = shareable
    }
    
}
