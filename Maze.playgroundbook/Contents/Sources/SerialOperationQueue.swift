//
//  SerialOperationQueue+MarkExplored.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 29/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation

// Perform actions after each other, in the order they were added to the queue
public class SerialOperationQueue {
    private let operationQueue = OperationQueue()

    public init() {
        self.operationQueue.maxConcurrentOperationCount = 1
    }

    public func add(_ action: @escaping () -> Void) {
        self.operationQueue.addOperation(action)
    }
}
