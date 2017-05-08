//
//  TicketsViewController.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 11/17/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ViewTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum Station: Int {
        case sjsu = 1
        case sjsuStadium = 2
        case diridon = 3
        case santaClara = 4
    }
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var ticketTableView: UITableView!

    
    var currentTickets = [Ticket]()
    var historyTickets = [Ticket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add code
        loadSampleTickets()
        ticketTableView.delegate = self
        ticketTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0;
        switch(segControl.selectedSegmentIndex) {
        case 0:
            returnValue =  currentTickets.count
        case 1:
            returnValue =  historyTickets.count
        default:
            break
        }
        return returnValue
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TicketTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TicketTableViewCell
        
        var tempTicket: Ticket? = nil
        switch(segControl.selectedSegmentIndex) {
        
        case 0:
            tempTicket = currentTickets[indexPath.row]
        case 1:
            tempTicket = historyTickets[indexPath.row]
        default:
            break
        }
        
        if let ticket = tempTicket {
            cell.stationFrom.text = String(ticket.from)
            cell.stationTo.text = String(ticket.to)
            cell.departureTime.text = ticket.time        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTicketSegue",
            let destination = segue.destination as? TicketViewController,
            let ticketIndex = ticketTableView.indexPathForSelectedRow?.row {
            switch (segControl.selectedSegmentIndex){
            case 0:
                print(ticketIndex)
                print(currentTickets[ticketIndex].from)
                print(currentTickets[ticketIndex].to)
                print(currentTickets[ticketIndex].date)
                print(currentTickets[ticketIndex].time)
                destination.ticket = currentTickets[ticketIndex]
            case 1:
                print(ticketIndex)
                print(historyTickets[ticketIndex].from)
                print(historyTickets[ticketIndex].to)
                print(historyTickets[ticketIndex].date)
                print(historyTickets[ticketIndex].time)
                destination.ticket = historyTickets[ticketIndex]
            default:
                break
            }
        }
    }

    func loadSampleTickets() {
        let ticket = Ticket(from:1, to: 2, date: Date(), time: "8:30 PM", shareable: false )
        let ticket1 = Ticket(from: 2, to: 3, date: Date(), time: "8:30 PM", shareable: false )
        let ticket2 = Ticket(from: 3, to: 4, date: Date(), time: "8:30 PM", shareable: false )
        
        let ticket3 = Ticket(from: 4, to: 1, date: Date(), time: "8:30 PM", shareable: false )
        let ticket4 = Ticket(from: 3, to: 2, date: Date(), time: "8:30 PM", shareable: false )
        let ticket5 = Ticket(from: 2, to: 1, date: Date(), time: "8:30 PM", shareable: false )
        
        currentTickets += [ticket, ticket1, ticket2]
        historyTickets += [ticket3, ticket4, ticket5]
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        ticketTableView.reloadData()
    }
    
//    func loadTickets() {
//        let uid = UserDefaults.standard.value(forKey: "uid")
//        let ref = FIRDatabase.database().reference()
//        let userRef = ref.child("users/\(uid)")
//        
//        
//    }
    
}
