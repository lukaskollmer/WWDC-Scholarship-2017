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
    public func clearAllExploredTiles(withDelay: TimeInterval = 0) {
        SerialOperationQueue.tileMarkingQueue.add {
            Thread.sleep(forTimeInterval: withDelay)

            self.allTiles.forEach {
                $0.markExplored(false, withDelay: 0)
            }
        }
    }
}