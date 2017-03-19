//
//  TileLocation.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation

public enum Direction : Int {
    case up, down, left, right
}

public struct TileLocation {
    public let row: Int
    public let column: Int

    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }


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

    public func isValid(inMaze: MazeData) -> Bool {
        guard row >= 0 && column >= 0 else { return false }

        return (self.column + 1) <= inMaze.numberOfColumns && (self.row + 1) <= inMaze.numberOfRows
    }
}


// MARK: Equation

extension TileLocation : Equatable { }

public func ==(lhs: TileLocation, rhs: TileLocation) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}
