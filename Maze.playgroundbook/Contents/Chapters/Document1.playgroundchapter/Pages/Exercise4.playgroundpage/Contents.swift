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

 var _playGameCalled = false

 /// Starts the Battleship game.
 func playGame() {
     _playGameCalled = true
 }

 //#-end-hidden-code
 //#-editable-code


 extension TileLocation {
     func costToMove(to: TileLocation) -> Int { return 1 }
 }

 func findPath(from: Tile, to: Tile) -> [TileLocation] {
     guard let maze = from.mazeScene else { return [] }

     var closedSteps = Set<ShortestPathStep>()
     var openSteps = [ShortestPathStep(position: from.location)]

     while !openSteps.isEmpty {
         let currentStep = openSteps.remove(at: 0)
         closedSteps.insert(currentStep)

         if currentStep.position == to.location {
             return convertStepsToShortestPath(lastStep: currentStep)
         }

         let neighboringLocations = maze.tile(atLocation: currentStep.position).neighbouringTiles.filter { maze.tile(atLocation: $0).state == .path }
         for location in neighboringLocations {
             var step = ShortestPathStep(position: location)
             if closedSteps.contains(step) {
                 continue
             }
             let moveCost = currentStep.position.costToMove(to: step.position)

             if let existingIndex = openSteps.index(of: step) {
                 var step = openSteps[existingIndex]
                 if currentStep.gScore + moveCost < step.gScore {
                     step.setParent(currentStep, withMoveCost: moveCost)

                     openSteps.remove(at: existingIndex)
                     insert(step: step, in: &openSteps)
                 }
             } else {
                 step.setParent(currentStep, withMoveCost: moveCost)
                 step.hScore = hScore(from: step.position, to: to.location)
                 insert(step: step, in: &openSteps)
             }
         }
     }
     return []
 }

 func insert(step: ShortestPathStep, in: inout [ShortestPathStep]) {
     `in`.append(step)
     `in`.sort { $0.fScore <= $1.fScore }
 }

 func hScore(from: TileLocation, to: TileLocation) -> Int {
     return abs(to.column - from.column) + abs(to.row - from.row)
 }

 func convertStepsToShortestPath(lastStep: ShortestPathStep) -> [TileLocation] {
     var shortestPath = [TileLocation]()
     var currentStep = lastStep
     while let parent = currentStep.parent {
         shortestPath.insert(currentStep.position, at: 0)
         currentStep = parent.value
     }
     return shortestPath
 }

 struct ShortestPathStep: Hashable {
     let position: TileLocation
     var parent: Indirect<ShortestPathStep>?

     var gScore = 0
     var hScore = 0
     var fScore: Int {
         return gScore + hScore
     }

     var hashValue: Int {
         return position.column.hashValue + position.row.hashValue
     }

     init(position: TileLocation) {
         self.position = position
     }

     mutating func setParent(_ parent: ShortestPathStep, withMoveCost: Int) {
         self.parent = Indirect<ShortestPathStep>(parent)
         self.gScore = parent.gScore + withMoveCost
     }
 }

 func ==(lhs: ShortestPathStep, rhs: ShortestPathStep) -> Bool {
     return lhs.position == rhs.position
 }

 playGame()
 //#-end-editable-code

 //#-hidden-code
 if _playGameCalled {
     let viewController = GameViewController()
     viewController.algorithm = .custom(findPath)
     PlaygroundPage.current.liveView = viewController
 }
 //#-end-hidden-code
