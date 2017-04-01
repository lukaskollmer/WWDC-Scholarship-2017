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
 **Goal:** In this exercise, you'll write code that gives the path between two tiles using the breadth-first algorithm.

 Your pathfinding function takes two `Tile` objects as parameters and should return an `Array<TileLocation>` containing the locations of all tiles of the path.

 Please note that the maze has it's origin in the lower left corner.

 You can use the `maze` object to get a specific tile:

 ```swift
 let location = TileLocation(row: 0, column: 0)
 let bottomLeftTile = maze.tile(atLocation: location)
 bottomLeftTile.color = .red
 ```

 Use the `neighboringTiles` property to get a `Tile`s neighboring tiles.

 You can create new `TileLocation` objects either by using the `init(row: Int, column: Int)` initializer or by using the `advanced(by: Int, inDirection: Direction)` function.

 Tip: Use the `PathStep` struct to store individual steps of your path. A `PathStep` object stores a `TileLocation` and a parent `PathStep` object. Use the `path` property to get an `Array<TileLocation>` representing the entire path from the start tile to the current one. This walks through all `parent` steps until it reaches the initial step.

 _Please note that due to the way Swift Playgrounds works, extensive use of the `print` function will slow down your algorithm by a lot._


 */
//#-hidden-code

// **TODOPerformance decrease due to enabled logging?**

import PlaygroundSupport


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

    return []
}

solveMaze(.custom(findPath))
//#-end-editable-code
