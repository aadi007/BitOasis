//
//  DataDisplayViewModel.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 2/1/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import Starscream
import Charts

protocol DataDisplayViewModelDelegate: class {
    func updateGraph(lineChartData: LineChartData, descriptionText: String)
}

final class DataDisplayViewModel: NSObject {
    private var socket: WebSocket?
    weak var delegate: DataDisplayViewModelDelegate?
    var lineChartEntry = [ChartDataEntry]()
    private var listenData = false
    private var dataOffset = 10
    private var dataCurrentCount = 0
    private var tickerDataList = [TickerData]()
    init(delegate: DataDisplayViewModelDelegate?) {
        self.delegate = delegate
    }
    func connectSocket() {
        socket = WebSocket(url: URL(string: "wss://api2.poloniex.com")!)
        socket?.delegate = self
        socket?.connect()
        listenData = true
    }
    func disconnectSocket() {
        socket?.disconnect()
    }
    func updateGraphData() {
        var lineChartEntry = [ChartDataEntry]()
        for tickerData in tickerDataList {
            let value = ChartDataEntry(x: tickerData.currencyPairId, y: tickerData.lastTradePrice)
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
        line1.colors = [UIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        delegate?.updateGraph(lineChartData: data, descriptionText: "My new graph")
    }
}
extension DataDisplayViewModel: WebSocketDelegate {
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
        if dataCurrentCount == dataOffset {
            //disconnect for now
            disconnectSocket()
        }
        if listenData {
            if let data = text.data(using: String.Encoding.utf8) {
                do {
                    let anyObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
                    if let responseArray = anyObject as? [Any], responseArray.count > 2 {
                        //parse the array
                        if let tickerData = Ticker(input: responseArray).tickerData {
                            tickerDataList.append(tickerData)
                        }
                        updateGraphData()
                        dataCurrentCount += 1
                } else {
                        print("No proper response")
                    }
                } catch (let error) {
                    print("error in parsing \(error.localizedDescription)")
                }
            }
        }
        print("did receive Message \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("did reveive data")
    }
}

