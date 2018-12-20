//
//  ViewController.swift
//  CurrencyConversionTask
//
//  Created by Mohansundaram Govindaraj on 12/19/18.
//  Copyright © 2018 Mohansundaram Govindaraj. All rights reserved.
//

import UIKit
import CurrencyConversion

class ViewController: UIViewController {
    
    @IBOutlet var sourceCurrencyTxtFld: UITextField!
    @IBOutlet var sourceCurrencyAmtTxtFld: UITextField!
    
    @IBOutlet var toCurrencyTxtFld: UITextField!
    @IBOutlet var toCurrencyAmtTxtFld: UITextField!
    
    var listOfCurrencies : [Currency] = []
    var pickerView : UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDoneButton(textField: sourceCurrencyAmtTxtFld)
        self.addDoneButton(textField: toCurrencyAmtTxtFld)
        
        CurrencyConversion.getAllCurrencies { [weak self] (currencies) in
            self?.listOfCurrencies = currencies
            
            DispatchQueue.main.async {
//                self?.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self?.view.frame.size.width ?? 320, height: 300))
                self?.pickerView = UIPickerView()
                
                guard let weakSelf = self, let picker = weakSelf.pickerView else {return}
                
//                let leadingConstr = NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: weakSelf.view, attribute: .leading, multiplier: 1.0, constant: 0)
//                let trailingConstr = NSLayoutConstraint(item: picker, attribute: .trailing, relatedBy: .equal, toItem: weakSelf.view, attribute: .trailing, multiplier: 1.0, constant: 0)
//                let topConstr = NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: weakSelf.view, attribute: .top, multiplier: 1.0, constant: 0)
//                let bottomConstr = NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: weakSelf.view, attribute: .bottom, multiplier: 1.0, constant: 0)
                
                let heightConstr = NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil,    attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
                
//                picker.addConstraints([leadingConstr,trailingConstr,topConstr,bottomConstr,heightConstr])
                picker.addConstraint(heightConstr)
                
                picker.dataSource = self
                picker.delegate = self
                
                weakSelf.toCurrencyTxtFld.inputView = picker
                weakSelf.addDoneButton(textField: weakSelf.toCurrencyTxtFld)
            }
        }
    }
    
    func addDoneButton(textField : UITextField) {
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexiButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:50))
        toolbar.items = [flexiButton,doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc func doneAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func convertAction(_ sender: Any) {
        
        guard toCurrencyTxtFld.text?.count ?? 0 > 0, sourceCurrencyAmtTxtFld.text?.count ?? 0 > 0 else {return}
        
        CurrencyConversion.convertCurrency(fromCurrency: "USD", toCurrency: toCurrencyTxtFld.text ?? "", amount: Double(sourceCurrencyAmtTxtFld.text ?? "") ?? 1) { [weak self] (convertedAmt, convertedStr) in
            
            DispatchQueue.main.async {
                self?.toCurrencyAmtTxtFld.text = convertedStr
            }
        }
    }
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == toCurrencyTxtFld {
            textField.inputView = pickerView
            pickerView?.reloadAllComponents()
            return true
        }
        return true
    }
}

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCurrencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = listOfCurrencies[row]
        return "\(currency.currency) \(currency.currencyNationality)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        toCurrencyTxtFld.text = listOfCurrencies[row].currency
    }
    
}
