//
//  ViewController.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 1/31/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    var socket: WebSocket?
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = WebSocket(url: URL(string: "wss://api2.poloniex.com")!)
        socket?.delegate = self
        socket?.connect()
    }
}

extension ViewController: WebSocketDelegate {
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
