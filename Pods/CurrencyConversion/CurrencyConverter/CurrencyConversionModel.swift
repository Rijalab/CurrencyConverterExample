//
//  CurrencyConversionModel.swift
//  CurrencyConverter
//
//  Created by Mohansundaram Govindaraj on 12/19/18.
//  Copyright © 2018 Mohansundaram Govindaraj. All rights reserved.
//

import UIKit

struct CurrencyConversionModel: Codable {

    var success : Bool
    var terms : String
    var privacy : String
    var timestamp : CLong
    var source : String
    var quotes : [String:Double]
}
