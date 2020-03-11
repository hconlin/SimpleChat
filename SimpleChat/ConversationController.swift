//
//  ConversationController.swift
//  DumbChat
//
//  Created by Hayden Conlin-Mouat on 2020-03-03.
//  Copyright © 2020 Hayden Conlin-Mouat. All rights reserved.
//

import UIKit
import SocketIO

class ConversationController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var nickname: String!
    var socket: SocketIOClient!
    var fromViewController: ViewController?
    //set socketURL: URL(string: "http://your-ip-address:8900")
    let manager = SocketManager(socketURL: URL(string: "http://localhost:8900")!, config: [.log(true), .compress])
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var numOfUsersLabel: UILabel!
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var leaveButton: UIButton!
    
    var messages = [Message]()
    
   override func viewDidLoad() {
        super.viewDidLoad()
        socket = manager.defaultSocket
        socket.connect()
        addHandlers()
        messageTable.delegate = self
        messageTable.dataSource = self
        messageField.delegate = self
        messageField.layer.borderWidth = 1.0
        messageField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        messageField.leftViewMode = .always
        messageField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func addHandlers(){
        
        socket.on("get messages"){ data, ack in
            if let messageDict = data[0] as? NSString {
                let myNSData = messageDict.data(using: String.Encoding.utf8.rawValue)!
                let json = try? JSONSerialization.jsonObject(with: myNSData, options: [])
                for message in json as! [Dictionary<String, String>]{
                    let user = message["user"]!
                    let text = message["msg"]!
                    let newMessage = Message(username: user, messageText: text)
                    self.messages.append(newMessage!)
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.messageTable.beginUpdates()
                    self.messageTable.insertRows(at: [indexPath], with: .automatic)
                    self.messageTable.endUpdates()
                }
            } else {
                print("error")
            }
        }
        
        socket.on("receivedMessage"){ data, ack in
            if let nickname = data[0] as? String, let msg = data[1] as? String {
                let newMessage = Message(username: nickname, messageText: msg)
                self.messages.append(newMessage!)
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.messageTable.beginUpdates()
                self.messageTable.insertRows(at: [indexPath], with: .automatic)
                self.messageTable.endUpdates()
            }
        }
        
        socket.on("user joined") { data, ack in
            if let numOfUsers = data[0] as? Int {
                self.numOfUsersLabel.text = String(numOfUsers)
            }
        }
        
        socket.on("user left") { data, ack in
            if let numOfUsers = data[0] as? String {
                self.numOfUsersLabel.text = String(numOfUsers)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageTableCell"
        
        guard let cell = messageTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableCell else {
            fatalError("The dequeued cell is not an instance of MessageTableCell.")
        }
        
        let newMessage = messages[indexPath.row]
        cell.nicknameLabel.text = newMessage.username
        cell.messageLabel.text = newMessage.messageText
        return cell
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        socket.emit("message", nickname, messageField.text!)
        messageField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func leave(_ sender: Any) {
        socket.disconnect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.nickname = nickname
        }
    }
}
