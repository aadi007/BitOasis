//
//  Ticket.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 1/31/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class Ticker {
    var channelId = 0
    var tickerData: TickerData
    init(input: [Any]) {
        if input.count > 3 {
            
        }
    }
}

class TickerData {
    var currencyPairId = 0
    var lastTradePrice = "0"
    var lowestAsk = "0"
    var highestBid = "0"
    var percentChangeIn24Hours = "0"
    var baseCurrencyVolumeIn24hours = "0"
    var isFrozen = false
    var highestPriceIn24Hours = "0"
    var lowestPriceIn24Hours = "0"
    
    init(input: [Any]) {
        
    }
}
