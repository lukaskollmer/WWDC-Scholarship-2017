//
//  PathStep.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 27/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


/// A struct describing a single step in a path through a maze
public struct PathStep: Hashable {
    // Movement cost from start tile to current tile
    public var movementCostToCurrentLocation = 0

    // Movement cost from current tile to destination tile
    public var movementCostToDestination = 0

    public var score: Int {
        return movementCostToCurrentLocation + movementCostToDestination
    }

    public var hashValue: Int {
        return location.hashValue
    }

    public var location: TileLocation

    /// The previous step
    public var parent: PathStep? {
        set {
            guard let newValue = newValue else {
                self.wrappedParent = nil
                return
            }
            self.wrappedParent = Indirect<PathStep>(newValue)
        }
        get {
            guard let wrappedParent = wrappedParent else { return nil }
            return wrappedParent.value
        }
    }
    private var wrappedParent: Indirect<PathStep>?

    /// Initialize the step using the specified location
    ///
    /// - Parameter location: `TileLocation`
    public init(location: TileLocation) {
        self.location = location
    }

    /// Set the parent of the step (parent = previous step)
    ///
    /// - Parameters:
    ///   - parent: The Parent
    ///   - moveCost: move cost from the parent to the current step
    public mutating func set(parent: PathStep, moveCost: Int) {
        self.parent = parent
        self.movementCostToCurrentLocation = parent.movementCostToCurrentLocation + moveCost
    }


    /// A `[TileLocation]` containing the entire path.
    public var path: [TileLocation] {
        var path = [TileLocation]()
        var currentStep = self
        while let parent = currentStep.parent {
            path.insert(currentStep.location, at: 0)
            currentStep = parent
        }
        return path
    }

    /// Calculate movement cost between two tiles
    ///
    /// - Parameters:
    ///   - from: start `TileLocation`
    ///   - to: end `TileLocation`
    /// - Returns: movement cost between these two tiles
    public static func h(from: TileLocation, to: TileLocation) -> Int {
        return abs(to.column - from.column) + abs(to.row - from.row)
    }
}

public func ==(lhs: PathStep, rhs: PathStep) -> Bool {
    return lhs.location == rhs.location
}
