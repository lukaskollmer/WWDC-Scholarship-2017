//
//  PathStep.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 27/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

// TODO: Use this in all examples, instead of the different existing ones.

public struct PathStep: Hashable {
    // Movement cost from start to current tile
    public var g = 0

    // Movement cost from current tile to destination
    public var h = 0

    public var score: Int {
        return g + h
    }

    public var hashValue: Int {
        return location.hashValue
    }

    public var location: TileLocation

    public var parent: PathStep? {
        set {
            guard let newValue = newValue else { return }
            self.wrappedParent = Indirect<PathStep>(newValue)
        }
        get {
            guard let wrappedParent = wrappedParent else { return nil }
            return wrappedParent.value
        }
    }
    private var wrappedParent: Indirect<PathStep>?

    public init(location: TileLocation) {
        self.location = location
    }

    public mutating func set(parent: PathStep, moveCost: Int) {
        self.parent = parent
        self.g = parent.g + moveCost
    }


    public var path: [TileLocation] {
        var path = [TileLocation]()
        var currentStep = self
        while let parent = currentStep.parent {
            path.insert(currentStep.location, at: 0)
            currentStep = parent
        }
        return path
    }

    public static func h(from: TileLocation, to: TileLocation) -> Int {
        return abs(to.column - from.column) + abs(to.row - from.row)
    }
}

public func ==(lhs: PathStep, rhs: PathStep) -> Bool {
    return lhs.location == rhs.location
}