//
//  CurrencyConversion.swift
//  CurrencyConverter
//
//  Created by Mohansundaram Govindaraj on 12/19/18.
//  Copyright © 2018 Mohansundaram Govindaraj. All rights reserved.
//

import UIKit

public class Currency : NSObject {
    public var currency: String = ""
    public var currencyNationality : String = ""
}

public class CurrencyConversion: NSObject {
    
    static let accessKey = "1ab743520368dc030ac549289908b470"
    
//    public let sharedInstance = CurrencyConversion()
    
    public class func getAllCurrencies(completionHandler: @escaping(_ currencyArray: [Currency])-> Void) {
        
        let urlString = "http://apilayer.net/api/list?access_key=\(CurrencyConversion.accessKey)"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (respData, urlResp, error) in
         
            guard let data = respData else {return}
            
            guard let jsonDict = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
            
            guard let currencies = jsonDict["currencies"] as? [String:String] else {return}
            
            var listOfCurrenciesModel = [Currency]()

            for (key, value) in currencies {
                let model = Currency()
                model.currency = key
                model.currencyNationality = value
                listOfCurrenciesModel.append(model)
            }
            
            completionHandler(listOfCurrenciesModel)
            
        }.resume()
    }

    public class func convertCurrency(fromCurrency : String, toCurrency: String, amount: Double, completionHandler: @escaping(_ convertedAmount: Double, _ convertedAmtString: String)-> Void) {
        
        // Source Currency change is not supported in this plan.
        let urlString = "http://apilayer.net/api/live?access_key=\(CurrencyConversion.accessKey)&currencies=\(toCurrency)&format=1"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (respData, urlResp, error) in
            
            guard let data = respData else {return}
            
            guard let respModel = try? JSONDecoder().decode(CurrencyConversionModel.self, from: data) else {return}
            
            guard let exchangeRate = respModel.quotes.values.first else {return}
            
            let convertedAmt = amount * exchangeRate
            
            completionHandler(convertedAmt,"\(toCurrency) \(convertedAmt)")
        
        }.resume()
    }
}
