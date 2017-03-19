//
//  Data.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import GameplayKit

public struct MazeData {
    public let numberOfRows: Int
    public let numberOfColumns: Int
    public let data: [[TileState]]

    public let gridGraph: GKGridGraph<GKGridGraphNode>

    public static func random(withSize: Int = 17) -> MazeData {
        return randomMaze(dimensions: withSize)
    }
}

