//
//  MainViewController.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 10/12/16.
//  Copyright © 2016 SpartanSuperway. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollFrame = CGRect(x: 0, y: 400, width: view.bounds.width, height:100)
        let scrollView = UIScrollView(frame: scrollFrame)
        scrollView.backgroundColor = UIColor.white
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        scrollView.contentSize = CGSize(width: 500, height: 100)
        
        
        let buttonFrame = CGRect(x: 0, y: 0, width: 80, height: 80)
        let purchaseTicketsButton = createBlueCircleButton(frame: buttonFrame, title: "Purchase Tickets")
        let viewTicketsButton = createBlueCircleButton(frame: buttonFrame, title: "View Tickets")
        let stackView = UIStackView(frame: scrollFrame)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.addSubview(purchaseTicketsButton)
        stackView.addSubview(viewTicketsButton)
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
    }

    func createBlueCircleButton(frame: CGRect, title: String) -> UIButton {
        let circleButton = UIButton(type: .custom)
        circleButton.frame = frame
        circleButton.layer.cornerRadius = circleButton.bounds.size.width/2
        circleButton.clipsToBounds = true
        circleButton.backgroundColor = UIColor.blue
        circleButton.setTitle(title, for: .normal)
        return circleButton
    }
}
