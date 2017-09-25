//
//  ViewController.swift
//  Calculator
//
//  Created by Marcello Tana on 19/09/17.
//  Copyright © 2017 Marcello Tana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        let textCurrentlyInDisplay = display!.text!
        
        if(userIsInTheMiddleOfTyping){
            if (digit=="."){
                if(!textCurrentlyInDisplay.contains(".")){
                    display.text=textCurrentlyInDisplay+digit
                }
            }
            else{
                display.text=textCurrentlyInDisplay+digit
            }
            
        }else{
            if (digit=="."){
                display.text="0."
            }
            else{
                display.text=digit
            }
            
            userIsInTheMiddleOfTyping = true
            
        }
        
        print("\(digit) was touched")
    }
    
    @IBOutlet weak var display: UILabel!
    
    private var brain:CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton)
    {
        if(userIsInTheMiddleOfTyping){
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping=false
        }
        userIsInTheMiddleOfTyping = false
        if let mathSymbol = sender.currentTitle{
            brain.performeOperation(mathSymbol)
        }
        if let result = brain.result{
            displayValue = result
        }
        
    }
}
