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
    func updateBarGraph(barChartData: BarChartData, descriptionText: String)
}

enum GraphType {
    case Line
    case Bar
}

final class DataDisplayViewModel: NSObject {
    private var socket: WebSocket?
    weak var delegate: DataDisplayViewModelDelegate?
    var lineChartEntry = [ChartDataEntry]()
    private var listenData = false
    private var dataOffset = 10
    private var dataCurrentCount = 0
    private var tickerDataList = [TickerData]()
    var graphType = GraphType.Line
    var thresholdValue: Double = -1
    init(delegate: DataDisplayViewModelDelegate?) {
        self.delegate = delegate
        dataCurrentCount = 0
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
        if graphType == .Line {
            var lineChartEntry = [ChartDataEntry]()
            var colors = [UIColor]()
            if thresholdValue == -1 {
                colors = [UIColor.blue]
            }
            for tickerData in tickerDataList {
                let value = ChartDataEntry(x: tickerData.currencyPairId, y: tickerData.lastTradePrice)
                lineChartEntry.append(value)
                if thresholdValue != -1 {
                    if tickerData.lastTradePrice >= thresholdValue {
                        colors.append(UIColor.green)
                    } else {
                        colors.append(UIColor.red)
                    }
                }
            }
            let line1 = LineChartDataSet(values: lineChartEntry, label: "Last trade price")
            line1.colors = [UIColor.blue]
            line1.mode = LineChartDataSet.Mode.horizontalBezier
            line1.circleColors = colors
            let data = LineChartData()
            data.addDataSet(line1)
            delegate?.updateGraph(lineChartData: data, descriptionText: "Exchange Trade Graph")
        } else {
            //bar graph data
            var barCharDataEntryList = [BarChartDataEntry]()
            var colors = [UIColor]()
            if thresholdValue == -1 {
                colors = [UIColor.blue]
            }
            for tickerData in tickerDataList {
                let value = BarChartDataEntry(x: tickerData.currencyPairId, y: tickerData.lastTradePrice)
                barCharDataEntryList.append(value)
                if thresholdValue != -1 {
                    if tickerData.lastTradePrice >= thresholdValue {
                        colors.append(UIColor.green)
                    } else {
                        colors.append(UIColor.red)
                    }
                }
            }
            let dataSet = BarChartDataSet(values: barCharDataEntryList, label: "Last trade price")
            dataSet.colors = colors
            let data = BarChartData(dataSets: [dataSet])
            delegate?.updateBarGraph(barChartData: data, descriptionText: "Exchange Trade Graph")
        }
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
        if listenData {
            if let data = text.data(using: String.Encoding.utf8) {
                do {
                    let anyObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
                    if let responseArray = anyObject as? [Any], responseArray.count > 2 {
                        //parse the array
                        dataCurrentCount += 1
                        if let tickerData = Ticker(input: responseArray).tickerData {
                            tickerDataList.append(tickerData)
                            if tickerDataList.count > dataOffset {
                                tickerDataList.removeFirst()
                            }
                        }
                        if tickerDataList.count % dataOffset == 0 {
                            updateGraphData()
                        }
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

