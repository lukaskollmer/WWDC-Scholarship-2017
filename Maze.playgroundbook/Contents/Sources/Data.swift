//
//  Data.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import GameplayKit

/// A structure describing a maze
public struct MazeData {
    /// Number of rows in the maze
    public let numberOfRows: Int
    
    /// Number of columns in the maze
    public let numberOfColumns: Int
    
    /// A nested array containing each tile's state (path or wall). If you want to get a specific tile's state, use it like this: `data[row][column]`
    public let data: [[TileState]]

    /// A `GKGridGraph` representing the maze
    public let gridGraph: GKGridGraph<GKGridGraphNode>

    /// Generate a new random maze
    ///
    /// - Parameter withSize: The maze's size (must be an odd integer, is same for #rows and #columns)
    /// - Returns: A new random maze
    public static func random(withSize: Int = 17) -> MazeData {
        return randomMaze(dimensions: withSize)
    }
}

