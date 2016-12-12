//
//  StatusControl.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 12/4/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class StatusControl: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var button: UIButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        button = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width))
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = button.bounds.size.width/2
        addSubview(button)
        
    }
    
    func setupEtaConnection() {
        var ref = FIRDatabase.database().reference()
        
        
    }

}
