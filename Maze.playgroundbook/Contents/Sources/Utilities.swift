//
//  Utilities.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation

public struct Utilities {
    /*
     Convert a `TimeInterval` (in seconds) to a human readable string (in milliseconds)
     */
    public static func string(fromTimeInterval: TimeInterval) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 5
        numberFormatter.minimumFractionDigits = 3
        numberFormatter.maximumIntegerDigits = 1

        let redactedTimeIntervalString = numberFormatter.string(from: NSNumber(value: fromTimeInterval))!
        let redactedTimeInterval = numberFormatter.number(from: redactedTimeIntervalString)!

        var duration = Measurement(value: redactedTimeInterval.doubleValue, unit: UnitDuration.seconds)
        duration.convert(to: .milliseconds)

        return String(describing: duration)
    }
}



public extension UnitDuration {
    public static var milliseconds: UnitDuration {
        // 1 ms = 1/1000 s
        return UnitDuration(symbol: "ms", converter: UnitConverterLinear(coefficient: 1/1000))
    }
}

public func toString<T: CustomStringConvertible>(_ obj: T) -> String {
    return obj.description
}

/**
 Check if any of the passed elements is true.
 For regular objects, this will check whether the object is nonnull
 For Bools, it will check if the bool is `true`

 (Should behave similar to Python's any function)
 */
public func any<T>(_ items: T?...) -> Bool {
    for item in items {
        if (item != nil) {
            guard item is Bool else { return true }
            if (item as! Bool) == true {
                return true
            }
        }
    }
    return false
}