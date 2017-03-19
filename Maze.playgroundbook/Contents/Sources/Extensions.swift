import Foundation
import UIKit
import SpriteKit

public extension Optional {
    public var isNil: Bool {
        return self == nil
    }
}

public enum CGPointDirection {
    case x, y
}

public extension CGPoint {
    public func advanced(by: CGFloat, inDirection: CGPointDirection) -> CGPoint {
        switch inDirection {
        case .x:
            return CGPoint(x: x + by, y: y)
        case .y:
            return CGPoint(x: x, y: y + by)
        }
    }
}

public extension SKNode {
    public var center: CGPoint {
        return self.position
            .advanced(by: 0.5 * self.frame.height, inDirection: .x)
            .advanced(by: 0.5 * self.frame.width,  inDirection: .y)
    }
}

// http://stackoverflow.com/a/26140302/2513803

/*
 Generate a random Int in a range
 */
public extension Int {
    public static func random(range: Range<Int>) -> Int {
        var offset = 0

        if range.lowerBound < 0 {  // allow negative ranges
            offset = abs(range.lowerBound)
        }

        let min = UInt32(range.lowerBound + offset)
        let max = UInt32(range.upperBound + offset)

        return Int(min + arc4random_uniform(max - min)) - offset
    }
}

/*
 Append the contents of one dictionary (rhs) to another (lhs)
 */
public func += <K, V>(lhs: inout [K:V], rhs: [K:V]) {
    for (k, v) in rhs {
        lhs.updateValue(v, forKey: k)
    }
}

/*
 Create a new dictionary bu merging two existing ones
 */
public func + <K,V>(lhs: [K:V], rhs: [K:V]) -> [K:V] {
    var map = [K:V]()
    for (k, v) in lhs {
        map[k] = v
    }
    for (k, v) in rhs {
        map[k] = v
    }
    return map
}

/*
 Get a random object from an array
 */
public extension Array {
    public var random: Element {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex]
    }
}


public extension Array where Element: FloatingPoint {
    /*
     Get the sum of the values of all objects in the array
     */
    public var total: Element {
        return reduce(0, +)
    }

    /*
     Get the average of the values of all objects in the array
     */
    public var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

public extension Array where Element: Integer {
    /*
     Get the sum of the values of all objects in the array
     */
    public var total: Element {
        return reduce(0, +)
    }
}

public extension Collection where Iterator.Element == Int, Index == Int {
    /*
     Get the average of the values of all objects in the array
     */
    public var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex-startIndex)
    }
}


public extension Dictionary {
    /*
     Get all keys in the dictionary as an Array<Key>
     */
    public var allKeys: [Key] {
        return [Key] (self.keys)
    }

    /*
     Get all values in the dictionary as an Array<Value>
     */
    public var allValues: [Value] {
        return [Value] (self.values)
    }
}