//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    //This is a delegate that tells the picker view what the rows should be named
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyNameArray[row]
    }
    //This is a delegate that when a value is picked, it grabs what index we chose in the UI
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Since we getCoinPrice takes in a string we use this const var
        let selectedRowCurrency: String = coinManager.currencyNameArray[row]
        coinManager.getCoinString(for: selectedRowCurrency)
        currencyLabel.text = selectedRowCurrency
    }
}
//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyNameArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
//MARK: - CoinManagerDegate
extension ViewController: CoinManagerDelegate {
    //CoinManagerDelegate
    func didUpdateCurrency(_ bitcoinPrice: Double) {
        DispatchQueue.main.sync {
            bitcoinLabel.text = String(format: "%.2f", bitcoinPrice)
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
