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
 **Solution:** Breadth-first algorithm

 This is an example-implementation of the [Breadth-first](glossary://Breadth-first%20search) pathfinding algorithm. It works by starting on the root level and then looking at each subsequent level of children nodes, until it finds the destination node.

 Unlike the A*-Algorithm, this does not use heuristics, since it doesn't assign weight to individual nodes.


 */
//#-hidden-code

// **TODOPerformance decrease due to enabled logging?**

import PlaygroundSupport
import Foundation


func solveMaze(_ algorithm: GameLogic.Algorithm) {
    let viewController = GameViewController(mode: .maze)
    viewController.algorithm = algorithm
    viewController.hints = ["Try comparing different neighboring tiles based on their distance to the destination."] // TODO change hint to something Breadth-first related
    PlaygroundPage.current.liveView = viewController
}

//#-end-hidden-code

//#-editable-code

func findPath(startTile: Tile, endTile: Tile) -> [TileLocation] {
    guard let maze = startTile.mazeScene else { return [] }

    // All TileLocations that still need to be explored
    var queue = Array<PathStep>()
    queue.append(PathStep(location: startTile.location))

    var exploredSteps = Set<PathStep>()

    while !queue.isEmpty {
        let currentStep = queue.removeFirst()
        exploredSteps.insert(currentStep)

        if currentStep.location == endTile.location {
            maze.clearAllExploredTiles()
            return currentStep.path
        }

        for location in maze.tile(atLocation: currentStep.location).neighboringTiles {
            guard location.state(inMaze: maze) == .path else { continue }

            maze.tile(atLocation: location).markExplored()

            var step = PathStep(location: location)

            if exploredSteps.contains(step) {
                continue
            }

            if let existingIndex = queue.index(of: step) {
                var step = queue[existingIndex]
                step.parent = currentStep

                queue.remove(at: existingIndex)
                queue.append(step)
            } else {
                step.parent = currentStep
                queue.append(step)
            }

        }
    }

    return []
}

solveMaze(.custom(findPath))
//#-end-editable-code
