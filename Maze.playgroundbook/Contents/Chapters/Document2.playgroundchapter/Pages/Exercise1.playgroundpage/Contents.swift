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
