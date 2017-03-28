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
 **Solution:** A*-Algorithm

 This is an example implementation of the A* pathfinding algorithm. It works by assigning a weight to each tile. This weight is equal to the distance between that tile and the initial tile, plus the distance between that tile and the destination tile. This weight represents a possible minimum distance between the initial tile and the destination tile. As a consequence of this, all paths with a greater weight can be discarded.



 This is an example implementation of the A* algorithm. It assigns a weight to each open tile location equal to the distance from the initial tile to that tile plus the distance from that tile to the destination tile. This approximate weight represents a minimum possible distance between that node and the destination. As a consequence of this, any path longer than that shortest weight can be discarded.

 Tap the _Run 100x_ button to record a larger sample size. You can see that this algorithm - whilst not matching the performance of the GameplayKit implementation - does indeed solve the maze pretty fast.

 */

 //#-hidden-code

 import PlaygroundSupport

 func solveMaze(_ algorithm: GameLogic.Algorithm) {
     let viewController = GameViewController(mode: .maze)
     viewController.algorithm = algorithm
     viewController.hints = ["Try comparing different neighboring tiles based on their distance to the destination."]
     PlaygroundPage.current.liveView = viewController
 }

 //#-end-hidden-code
 //#-editable-code

 func findPath(from: Tile, to: Tile) -> [TileLocation] {
     guard let maze = from.mazeScene else { return [] }

     var closedSteps = Set<PathStep>()
     var openSteps = [PathStep(location: from.location)]

     while !openSteps.isEmpty {
         let currentStep = openSteps.remove(at: 0)
         closedSteps.insert(currentStep)

         if currentStep.location == to.location {
             return currentStep.path
         }

         for location in maze.tile(atLocation: currentStep.location).neighboringTiles {
             guard location.state(inMaze: maze) == .path else { continue }
             
             var step = PathStep(location: location)
             if closedSteps.contains(step) {
                 continue
             }

             let moveCost = 1 // Move cost is always 1 because we can only make one step at a time

             if let existingIndex = openSteps.index(of: step) {
                 var step = openSteps[existingIndex]
                 if currentStep.score + moveCost < step.score {
                     step.set(parent: currentStep, moveCost: moveCost)

                     openSteps.remove(at: existingIndex)
                     openSteps.append(step)
                     openSteps.sort { $0.score <= $1.score }
                 }
             } else {
                 step.set(parent: currentStep, moveCost: moveCost)
                 step.h = PathStep.h(from: step.location, to: to.location)
                 openSteps.append(step)
                 openSteps.sort { $0.score <= $1.score }
             }
         }
     }
     return []
 }


 solveMaze(.custom(findPath))
 //#-end-editable-code
