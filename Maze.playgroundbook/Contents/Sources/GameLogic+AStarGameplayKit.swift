//
//  GameLogic+AStarGameplayKit.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation
import GameplayKit

func ==(_ lhs: vector_float2, _ rhs: vector_int2) -> Bool {
    return lhs.x == Float(rhs.x) && lhs.y == Float(rhs.y)
}


extension GameLogic {
    /// Find a path using GameplayKit's A* implementation
    ///
    /// - Parameters:
    ///   - from: Start Tile
    ///   - to: End Tile
    /// - Returns: An `[TileLocation]` describing the path
    static func findAStar(from: Tile, to: Tile) -> [TileLocation] {
        guard let maze = from.mazeScene else { return [] }

        // We can save a ton of time by using the grid created by the maze generator
        // However since a GKGridGraph has its origin in the upper left corner, we need to 'flip' all x-coordinates

        let grid = maze.maze.gridGraph

        let startLocation = TileLocation(row: abs(maze.numberOfRows - from.location.row - 1), column: from.location.column)
        let endLocation = TileLocation(row: abs(maze.numberOfRows - to.location.row - 1), column: to.location.column)


        guard let startNode = grid.node(atGridPosition: int2(x: Int32(startLocation.row), y: Int32(startLocation.column))),
            let endNode = grid.node(atGridPosition: int2(x: Int32(endLocation.row), y: Int32(endLocation.column))) else { return [] }


        guard let path: [GKGridGraphNode] = grid.findPath(from: startNode, to: endNode) as? [GKGridGraphNode] else { return  [] }

        return path.map { node in
            let row = abs(maze.numberOfRows - Int(node.gridPosition.x) - 1)
            let column = Int(node.gridPosition.y)
            return TileLocation(row: row, column: column)
        }
    }
}
