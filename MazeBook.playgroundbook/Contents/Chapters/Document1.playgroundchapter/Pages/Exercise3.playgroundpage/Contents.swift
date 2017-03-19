//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Lukas Kollmer. All Rights Reserved.
//
//#-end-hidden-code
/*:

 **TODO** Remove this example or replace it w/ Breadth-first search

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

 func findPath(from: Tile, to: Tile) -> [TileLocation] {
     guard let mazeScene = from.mazeScene else { return [] }

     var didFindTarget = false
     var currentTile = from
     var path = [from.location]

     while !didFindTarget {
         var possibleLocations = [TileLocation]()

         let loadPossibleLocations = {
             possibleLocations = currentTile.neighbouringTiles
                 .filter { mazeScene.tile(atLocation: $0).state == .path }
                 .filter { !path.contains($0) }
         }

         loadPossibleLocations()

         if possibleLocations.isEmpty {
             path = [from.location]
             currentTile = from
             loadPossibleLocations()
         }

         let nextLocation = possibleLocations.random

         currentTile = mazeScene.tile(atLocation: nextLocation)
         path.append(nextLocation)

         if currentTile == to {
             didFindTarget = true
         }
     }
     return path
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
