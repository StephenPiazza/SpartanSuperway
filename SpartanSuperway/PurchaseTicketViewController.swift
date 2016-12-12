//
//  PurchaseTicketViewController.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 11/17/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PurchaseTicketViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var locationFrom: UITextField!
    @IBOutlet weak var locationTo: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    
    var ticket: Ticket = Ticket(from: "HI", to: "Hello", date: Date(), time: "8:30 PM", shareable: true)
    
    var pickerView1: UIPickerView?
    var pickerView2: UIPickerView?
    
    var pickerOptions = ["Palo Alto","Cupertino","Sunnyvale","San Jose","Fremont","Mountain View"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView1 = UIPickerView()
        pickerView1!.delegate = self
        locationFrom.inputView = pickerView1
        
        pickerView2 = UIPickerView()
        pickerView2!.delegate = self
        locationTo.inputView = pickerView2
        
    }
    
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minimumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @IBAction func timeFieldEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(timePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @IBAction func purchaseTicket(_ sender: Any) {
        let from = locationFrom.text!
        let to = locationTo.text!
        let ticketDate = date.text!
        let ticketTime = time.text!
        let rideShare = false;
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let timeDate = dateFormatter.date(from: ticketDate)
        print("\(timeDate)")
        let tempTicket = Ticket(from: from, to: to, date: timeDate!, time: ticketTime, shareable: rideShare)
        self.ticket = tempTicket
        
        store(ticket: self.ticket)
        
//
//        definesPresentationContext = true
//        let ticketViewController = TicketViewController()
//        ticketViewController.modalTransitionStyle = .crossDissolve
//        ticketViewController.modalPresentationStyle = .overCurrentContext
//        present(ticketViewController, animated: true, completion: nil)
//        modalPresentationStyle = .overCurrentContext
//        performSegue(withIdentifier: "ticketSegue", sender: self)
        
    }
    
    func store(ticket: Ticket) {
        
        let user = FIRAuth.auth()?.currentUser
        if let uid = user?.uid {
        print(uid)
        
        let ref = FIRDatabase.database().reference()
        ref.child("users/\(uid)/currentTicket/from").setValue(ticket.from)
        ref.child("users/\(uid)/currentTicket/to").setValue(ticket.to)
        ref.child("users/\(uid)/currentTicket/eta").setValue(10)
        ref.child("users/\(uid)/currentTicket/status").setValue(100)
        ref.child("users/\(uid)/currentTicket/alive").setValue(true)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTicketSegue1",
            let destination = segue.destination as? TicketViewController {
                destination.ticket = self.ticket
        }
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        date.text = dateFormatter.string(from: sender.date)
    }
    
    func timePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.none
        time.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
           
            locationFrom.text = pickerOptions[row]
        } else if pickerView == pickerView2 {
            locationTo.text = pickerOptions[row]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing((true))
        super.touchesBegan(touches, with: event)
    }
    
    
}
