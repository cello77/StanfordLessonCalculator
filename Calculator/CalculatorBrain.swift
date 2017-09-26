//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Marcello Tana on 24/09/17.
//  Copyright © 2017 Marcello Tana. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double,Double)->Double)
        case equals()
    }
    
    private var accumulator:Double?
    private var description:String?
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    
    private var operations:Dictionary<String,Operation> =
        [
            "𝜋" : Operation.constant(Double.pi),
            "𝜋/2" : Operation.constant(Double.pi/2),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos": Operation.unaryOperation(cos),
            "sin": Operation.unaryOperation(sin),
            "^2":Operation.unaryOperation({$0*$0}),
            "±" : Operation.unaryOperation({-$0}),
            "x" : Operation.binaryOperation({ $0 * $1}),
            "/" : Operation.binaryOperation({ $0.truncatingRemainder(dividingBy:$1)}),
            "÷" : Operation.binaryOperation({ $0 / $1}),
            "+" : Operation.binaryOperation({ $0 + $1}),
            "-" : Operation.binaryOperation({ $0 - $1}),
            "=" : Operation.equals()
    ]
    
    private var resultIsPending:Bool{
        get{
            return pendingBinaryOperation != nil
        }
    }
    
    
    var result:Double?{
        get{
            return accumulator
        }
        
    }
    
    private struct PendingBinaryOperation{
        let function:(Double,Double)->Double
        let firstOperand : Double
        func performOperation(with secondOperand:Double)->Double{
            return function(firstOperand,secondOperand)
        }
    }
    
    
    
    mutating func performeOperation(_ symbol:String){
        if let operation = operations[symbol]{
            switch(operation){
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if (accumulator != nil) {
                    accumulator = function(accumulator!)
                    addToDescription(symbol)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals():
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if(pendingBinaryOperation != nil && accumulator != nil){
            accumulator = pendingBinaryOperation?.performOperation(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand:Double){
        accumulator = operand;
        addToDescription(String(operand))
    }
    
    public func getCompleteOperation()->String{
        return description!
    }
    
    mutating private func addToDescription(_ str:String){
        if description != nil{
            description!.append(" " + String(str))
        }else{
            description = String(str)
        }
    }
    
}

