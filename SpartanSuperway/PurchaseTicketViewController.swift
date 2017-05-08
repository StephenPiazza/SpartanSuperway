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

class PurchaseTicketViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    enum Station: Int {
        case sjsu = 1
        case sjsuStadium = 2
        case diridon = 3
        case santaClara = 4
    }
    
    @IBOutlet weak var locationFrom: UITextField!
    @IBOutlet weak var locationTo: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    
    var ticket: Ticket = Ticket(from: 1, to: 2, date: Date(), time: "8:30 PM", shareable: true)
    
    var pickerView1: UIPickerView?
    var pickerView2: UIPickerView?
    
//    var pickerOptions = ["SJSU","SJSU Stadium","Diridon","Santa Clara"]
    var pickerOptions = ["Station 1","Station 2","Station 3","Station 4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1 = UIPickerView()
        pickerView1!.delegate = self
        locationFrom.inputView = pickerView1
        locationFrom.text = pickerOptions[0]
        
        pickerView2 = UIPickerView()
        pickerView2!.delegate = self
        locationTo.inputView = pickerView2
        locationTo.text = pickerOptions[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        date.text = dateFormatter.string(for: Date.init())
        
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.none
        time.text = dateFormatter.string(for: Date.init())
        
        
    }
    
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minimumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @IBAction func timeFieldEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
    }
    
    @IBAction func purchaseTicket(_ sender: Any) {
        
        var from = 0;
        print(locationFrom.text!)
        switch (locationFrom.text!) {
        case "SJSU":
            from = Station.sjsu.rawValue
        case "SJSU Stadium":
            from = Station.sjsuStadium.rawValue
        case "Diridon":
            from = Station.diridon.rawValue
        case "Santa Clara":
            from = Station.santaClara.rawValue
        case "Station 1":
            from = 1
        case "Station 2":
            from = 2
        case "Station 3":
            from = 3
        case "Station 4":
            from = 4
        default:
            break
        }
        
        var to = 0;
        
        print(locationTo.text!)
        switch (locationTo.text!) {
        case "SJSU":
            to = Station.sjsu.rawValue
        case "SJSU Stadium":
            to = Station.sjsuStadium.rawValue
        case "Diridon":
            to = Station.diridon.rawValue
        case "Santa Clara":
            to = Station.santaClara.rawValue
        case "Station 1":
            to = 1
        case "Station 2":
            to = 2
        case "Station 3":
            to = 3
        case "Station 4":
            to = 4
        default:
            break
        }
        
        let ticketDate = date.text!
        let ticketTime = time.text!
        let rideShare = false;
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let timeDate = dateFormatter.date(from: ticketDate)
        print("\(timeDate)")
        print(from)
        print(to)
        let tempTicket = Ticket(from: from, to: to, date: timeDate!, time: ticketTime, shareable: rideShare)
        self.ticket = tempTicket
        print(self.ticket)
        store(self.ticket)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TicketViewController") as! TicketViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)

//        definesPresentationContext = true
//        let ticketViewController = TicketViewController()
//        ticketViewController.modalTransitionStyle = .crossDissolve
//        ticketViewController.modalPresentationStyle = .overCurrentContext
//        present(ticketViewController, animated: true, completion: nil)
//        modalPresentationStyle = .overCurrentContext
//        self.present(ticketViewController, animated: true, completion: nil)
        
    }
    
    func store(_ ticket: Ticket) {
        
        print(ticket)
        let user = FIRAuth.auth()?.currentUser
        if let uid = user?.uid {
            print(uid)
            
            let ref = FIRDatabase.database().reference()
            ref.child("users/\(uid)/currentTicket/from").setValue(ticket.from)
            ref.child("users/\(uid)/currentTicket/to").setValue(ticket.to)
            ref.child("users/\(uid)/currentTicket/eta").setValue(10)
            ref.child("users/\(uid)/currentTicket/status").setValue(100)
            ref.child("users/\(uid)/currentTicket/isNewTicket").setValue(true)
            ref.child("users/\(uid)/currentTicket/timerOn").setValue(false)
        
        }
        
//        let vc = UIStoryboard(name: "TicketViewController", bundle: nil).instantiateViewController(withIdentifier: "TicketViewController")
//        self.present(vc, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTicketSegue1",
            let destination = segue.destination as? TicketViewController {
                destination.ticket = self.ticket
        }
    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == time {
//            let timePickerView = UIDatePicker()
//            timePickerView.datePickerMode = UIDatePickerMode.time
//            textField.inputView = timePickerView
//            timePickerView.addTarget(self, action: #selector(timePickerValueChanged(sender:)), for: .valueChanged)
//
//        }
//        else if textField == date {
//            let datePickerView = UIDatePicker()
//            datePickerView.datePickerMode = UIDatePickerMode.date
//            datePickerView.minimumDate = Date()
//            datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
//
//        }
//    }
//    
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        date.text = dateFormatter.string(from: sender.date)
    }
    
    func timePickerValueChanged(_ sender:UIDatePicker) {
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
