//
//  ViewController.swift
//  DumbChat
//
//  Created by Hayden Conlin-Mouat on 2020-03-03.
//  Copyright © 2020 Hayden Conlin-Mouat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var nicknameLabel: UITextField!
    
    var nickname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        joinButton.layer.cornerRadius = 20
        nicknameLabel.text = nickname
        nicknameLabel.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ConversationController {
            let vc = segue.destination as? ConversationController
            if nicknameLabel.text == "" {
                vc?.nickname = "Guest User"
            } else {
                vc?.nickname = nicknameLabel.text!
            }
        }
    }
}

