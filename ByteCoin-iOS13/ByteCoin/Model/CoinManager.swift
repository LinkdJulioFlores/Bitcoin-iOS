//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
// Completed by Julio Flores

import Foundation
protocol CoinManagerDelegate{
    func didUpdateCurrency(_ bitcoinPrice: Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=1DBF9863-8E42-451E-820E-3275D15ED02E"
    
    var delegate: CoinManagerDelegate?
    
    let currencyNameArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    

    func getCoinString(for currency: String) {
        let URL = "\(baseURL)/\(currency)\(apiKey)"
        performRequest(with: URL)
    }
    
    func performRequest(with urlString: String){
        //1: Create URL String
        if let URL = URL(string: urlString){
            //2: Create a URL Session
            let session = URLSession(configuration: .default)
            //3: Give the session a task
            let task = session.dataTask(with: URL) { data, response, error in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data {
                    //var printableData = String(data: safeData, encoding: String.Encoding.utf8) as String?
                    let bitcoinPrice: Double = self.parseJSON(safeData)
                    delegate?.didUpdateCurrency(bitcoinPrice)
                }
            }
            //4: Start the session
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return 0.0
        }
    }
}
