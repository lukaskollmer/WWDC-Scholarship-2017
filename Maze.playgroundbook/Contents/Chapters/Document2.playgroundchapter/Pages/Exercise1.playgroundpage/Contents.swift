//#-hidden-code
//
//  Contents.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Breadth-first implementation
 _Please note that, due to the way Swift Playgrounds works, extensive use of the `print` function will slow down your algorithm by a lot._


 */
//#-hidden-code

// **TODOPerformance decrease due to enabled logging?**

import PlaygroundSupport
import Foundation


func solveMaze(_ algorithm: GameLogic.Algorithm) {
    let viewController = GameViewController(mode: .maze)
    viewController.algorithm = algorithm
    viewController.hints = ["Try comparing different neighboring tiles based on their distance to the destination."]
    PlaygroundPage.current.liveView = viewController
}

//#-end-hidden-code

//#-editable-code

struct PathStep: Hashable {
    let location: TileLocation
    var previous: Indirect<PathStep>?

    init(location: TileLocation) {
        self.location = location
    }

    var hashValue: Int {
        return self.location.hashValue
    }

    var path: [TileLocation] {
        var path = [TileLocation]()
        var currentStep = self
        while let parent = currentStep.previous {
            path.insert(currentStep.location, at: 0)
            currentStep = parent.value
        }
        return path
    }
}

func ==(lhs: PathStep, rhs: PathStep) -> Bool {
    return lhs.location == rhs.location
}

func findPath(startTile: Tile, endTile: Tile) -> [TileLocation] {
    guard let maze = startTile.mazeScene else { return [] }

    var queue = Array<PathStep>()
    queue.append(PathStep(location: startTile.location))

    var exploredSteps = Set<PathStep>()

    while !queue.isEmpty {
        let currentStep = queue.removeFirst()
        exploredSteps.insert(currentStep)

        if currentStep.location == endTile.location {
            return currentStep.path
        }

        for location in maze.tile(atLocation: currentStep.location).neighboringTiles {
            guard maze.tile(atLocation: location).state == .path else { continue }

            var step = PathStep(location: location)

            if exploredSteps.contains(step) {
                continue
            }

            if let existingIndex = queue.index(of: step) {
                var step = queue[existingIndex]
                step.previous = Indirect<PathStep>(currentStep)

                queue.remove(at: existingIndex)
                queue.append(step)
            } else {
                step.previous = Indirect<PathStep>(currentStep)
                queue.append(step)
            }

        }
    }

    return []
}

solveMaze(.custom(findPath))
//#-end-editable-code
