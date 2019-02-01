//
//  Ticket.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 1/31/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class Ticker {
    var channelId: Double = 0
    var tickerData: TickerData!
    init(input: [Any]) {
        channelId = input[0] as! Double
        var tickerDataArray = input
        tickerDataArray.removeFirst(2)
        tickerData = TickerData(input: tickerDataArray[0] as! [Any])
    }
}

class TickerData {
    var currencyPairId: Double = 0
    var lastTradePrice: Double = 0
    var lowestAsk = "0"
    var highestBid = "0"
    var percentChangeIn24Hours = "0"
    var baseCurrencyVolumeIn24hours = "0"
    var baseQuoteVolumeIn24hours = "0"
    var isFrozen = false
    var highestPriceIn24Hours = "0"
    var lowestPriceIn24Hours = "0"
    
    init(input: [Any]) {
        currencyPairId = input[0] as! Double
        if let lastTradePriceObject = input[1] as? String, let doubleValue = Double(lastTradePriceObject) {
            lastTradePrice = doubleValue
        }
        lowestAsk = input[2] as! String
        highestBid = input[3] as! String
        percentChangeIn24Hours = input[4] as! String
        baseCurrencyVolumeIn24hours = input[5] as! String
        baseQuoteVolumeIn24hours = input[6] as! String
        isFrozen = input[7] as! Bool
        highestPriceIn24Hours = input[8] as! String
        lowestPriceIn24Hours = input[9] as! String
    }
}
