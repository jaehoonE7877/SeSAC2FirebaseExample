//
//  ViewController.swift
//  SeSAC2FirebaseExample
//
//  Created by Seo Jae Hoon on 2022/10/05.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("rejack", parameters: [
          "name": "고래밥",
          "full_text": "안녕하세요",
        ])
        
        Analytics.setDefaultEventParameters([
          "level_name": "Caverns01",
          "level_difficulty": 4
        ])

    }
    
    @IBAction func crashButtonClicked(_ sender: UIButton) {
    }
    
}

