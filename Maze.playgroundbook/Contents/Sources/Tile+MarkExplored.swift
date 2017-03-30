//
//  Tile+MarkExplored.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 29/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import SpriteKit

public extension SerialOperationQueue {
    public static let tileMarkingQueue = SerialOperationQueue()
}


public extension Tile {
    /// Mark a Tile explored (This will change the Tile's color to a light gray after a small time interval
    ///
    /// - Parameters:
    ///   - isExplored: Boolean determining whether the tile has already been explored (defaults to `true`)
    ///   - withDelay: `TimeInterval` specifying the delay that should be used when changing the tile's color (defaults to `0.05`)
    public func markExplored(_ isExplored: Bool = true, withDelay: TimeInterval = 0.05) {
        SerialOperationQueue.tileMarkingQueue.add {
            DispatchQueue.main.async {
                let color: UIColor = isExplored ? .lightGray : self.state.color
                let action = SKAction.colorize(with: color, colorBlendFactor: 0, duration: withDelay)
                self.run(action)
            }

            Thread.sleep(forTimeInterval: withDelay)
        }
    }
}

public extension MazeScene {
    /// Clear all explored tiles in a maze
    ///
    /// - Parameter withDelay: `TimeInterval` specifying the delay that should be used
    public func clearAllExploredTiles(withDelay: TimeInterval = 0) {
        SerialOperationQueue.tileMarkingQueue.add {
            Thread.sleep(forTimeInterval: withDelay)

            self.allTiles.forEach {
                $0.markExplored(false, withDelay: 0)
            }
        }
    }
}
