//
//  DataDisplayViewController.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 1/31/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import Starscream
import FirebaseAuth

class DataDisplayViewController: UIViewController {
    var socket: WebSocket?
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = WebSocket(url: URL(string: "wss://api2.poloniex.com")!)
        socket?.delegate = self
        socket?.connect()
        configureNavigationBar()
    }
    func configureNavigationBar() {
        self.navigationItem.hidesBackButton = true
        let button = UIButton(type: .custom)
        button.setTitle("Sign out", for: .normal)
        button.target(forAction: #selector(deleteUserButtonTapped), withSender: self)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: button), animated: true)
    }
    @objc func SignOutButtonTapped() {
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (action) in
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let error = error {
                    // An error happened.
                    print("error occurred \(error.localizedDescription)")
                } else {
                    // Account deleted.
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension DataDisplayViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        var command = [String: Any]()
        command["command"] = "subscribe"
        command["channel"] = 1002
        do {
            let input = try JSONSerialization.data(withJSONObject: command, options: .prettyPrinted)
            socket.write(data: input)
        } catch {
            return
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("did receive Message \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("did reveive data")
    }
    
    
}
