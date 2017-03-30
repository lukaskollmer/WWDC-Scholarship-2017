//
//  TileLocation.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation

/// Direction
///
/// - up: Go 1 point up
/// - down: Go 1 point down
/// - left: Go 1 point left
/// - right: Go 1 point right
public enum Direction : Int {
    case up, down, left, right
}

/// Struct describing a `Tile`s location in a maze
public struct TileLocation {
    /// The Tile's row
    public let row: Int
    
    /// The Tile's column
    public let column: Int

    public static let invalid = TileLocation(row: -1, column: -1)

    /// Initialize w/ the specified row & column
    ///
    /// - Parameters:
    ///   - row: Row
    ///   - column: Column
    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }


    /// Create a new `TileLocation` by moving the specified amount of steps in the specified direction/. Please note that the resulting `TileLocation` may be invalid in the maze. You can use the `isValid(inMaze:)` function to check
    ///
    /// - Parameters:
    ///   - by: Number of steps to move
    ///   - inDirection: Direction to move towards
    /// - Returns: `TileLocation`
    public func advanced(by: Int, inDirection: Direction) -> TileLocation {
        switch inDirection {
        case .up:
            return TileLocation(row: row, column: column.advanced(by: by))
        case .down:
            return TileLocation(row: row, column: column.advanced(by: -by))
        case .left:
            return TileLocation(row: row.advanced(by: -by), column: column)
        case .right:
            return TileLocation(row: row.advanced(by: by), column: column)
        }
    }

    /// Check whether a `TileLocation` is valid in a maze
    ///
    /// - Parameter inMaze: `MazeData` describing the maze
    /// - Returns: Boolean determinging whether the location is valid
    public func isValid(inMaze: MazeData) -> Bool {
        guard row >= 0 && column >= 0 else { return false }

        return (self.column + 1) <= inMaze.numberOfColumns && (self.row + 1) <= inMaze.numberOfRows
    }

    /// The state of a `TileLocation` in a maze
    ///
    /// - Parameter inMaze: The maze to check for
    /// - Returns: `TileState`
    public func state(inMaze: MazeScene) -> TileState {
        return inMaze.tile(atLocation: self).state
    }
}

extension TileLocation: CustomStringConvertible {
    public var description: String {
        return "TileLocation(row: \(self.row), column: \(self.column))"
    }
}

extension TileLocation : Equatable { }

public func ==(lhs: TileLocation, rhs: TileLocation) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}

extension TileLocation: Hashable {
    public var hashValue: Int {
        return self.description.hashValue
    }
}
