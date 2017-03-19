//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Lukas Kollmer. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Write an algorithm to find the shortest path between two tiles as efficently as possible

 This is an example implementation of the A* pathfinding algorithm. It works by assigning a weight to each tile. This weight is equal to the distance between that tile and the initial tile, plus the distance between that tile and the destination tile. This weight represents a possible minimum distance between the initial tile and the destination tile. As a consequence of this, all paths with a greater weight can be discarded.



 This is an example implementation of the A* algorithm. It assigns a weight to each open tile location equal to the distance from the initial tile to that tile plus the distance from that tile to the destination tile. This approximate weight represents a minimum possible distance between that node and the destination. As a consequence of this, any path longer than that shortest weight can be discarded.

 Tap the _Run 100x_ button to record a larger sample size. You can see that this algorithm - whilst not matching the performance of the GameplayKit implementation - does indeed solve the maze pretty fast.

 */

 //#-hidden-code

 import PlaygroundSupport

 func playGame(_ algorithm: GameLogic.Algorithm) {
     let viewController = GameViewController()
     viewController.algorithm = algorithm
     viewController.hints = ["Try comparing different neighboring tiles based on their distance to the destination."]
     PlaygroundPage.current.liveView = viewController
 }

 //#-end-hidden-code
 //#-editable-code

 func findPath(from: Tile, to: Tile) -> [TileLocation] {
     guard let maze = from.mazeScene else { return [] }

     var closedSteps = Set<PathStep>()
     var openSteps = [PathStep(position: from.location)]

     while !openSteps.isEmpty {
         let currentStep = openSteps.remove(at: 0)
         closedSteps.insert(currentStep)

         if currentStep.position == to.location {
             return currentStep.path
         }

         let neighboringLocations = maze.tile(atLocation: currentStep.position).neighbouringTiles.filter { maze.tile(atLocation: $0).state == .path }
         for location in neighboringLocations {
             var step = PathStep(position: location)
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
                 step.h = PathStep.h(from: step.position, to: to.location)
                 openSteps.append(step)
                 openSteps.sort { $0.score <= $1.score }
             }
         }
     }
     return []
 }

 struct PathStep: Hashable {
     // Movement cost from start to current tile
     var g = 0

     // Movement cost from current tile to destination
     var h = 0

     var score: Int {
         return h + h
     }

     var hashValue: Int {
         return position.column.hashValue + position.row.hashValue
     }

     var position: TileLocation
     private(set) var parent: Indirect<PathStep>?

     init(position: TileLocation) {
         self.position = position
     }

     mutating func set(parent: PathStep, moveCost: Int) {
         self.parent = Indirect<PathStep>(parent)
         self.g = parent.g + moveCost
     }


     var path: [TileLocation] {
         var path = [TileLocation]()
         var currentStep = self
         while let parent = currentStep.parent {
             path.insert(currentStep.position, at: 0)
             currentStep = parent.value
         }
         return path
     }

     static func h(from: TileLocation, to: TileLocation) -> Int {
         return abs(to.column - from.column) + abs(to.row - from.row)
     }
 }

 func ==(lhs: PathStep, rhs: PathStep) -> Bool {
     return lhs.position == rhs.position
 }


 playGame(.custom(findPath))
 //#-end-editable-code
