//
//  SerialOperationQueue+MarkExplored.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 29/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation

// Perform actions onw after another, in the order they were added to the queue
// This is used by the live maze exploration progress thing (call `markExplored()` on each tile you explored and call `maze.clearAllExploredTiles()` once you've found a path)
// The idea behind this is to have one shared SerialOperationQueue object for the entire playground, to make sure all maze exploration updated are executed in order, to visualize the progress.

public class SerialOperationQueue {
    private let operationQueue = OperationQueue()

    public init() {
        self.operationQueue.maxConcurrentOperationCount = 1
    }

    /// Add a new operation to the queue
    ///
    /// - Parameter action: <#action description#>
    public func add(_ action: @escaping () -> Void) {
        self.operationQueue.addOperation(action)
    }
}
