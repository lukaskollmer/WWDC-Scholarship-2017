//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Lukas Kollmer. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Write an algorithm to find the shortest path between two tiles as efficently as possible

 In this exercise, you'll write code that gives the path between two tiles. Tap _Run My Code_ to reload the game with your new algorithm.

 Select two tiles to calculate the path between them. You can also use the _Run 100x_ button to gather a larger sample size.
 The stats view below the maze will display the average duration across all 100 runs, as well as the duration of the fastest and the slowest run.

 Your pathfinding function takes two `Tile` objects as parameters and should return an `Array<TileLocation>` containg the locations of all tiles of the path.

 Please note that the maze has it's origin in the lower left corner.

 You can use the `maze` object to get a specific tile:

 ```swift
 let location = TileLocation(row: 0, column: 0)
 let bottomLeftTile = maze.tile(atLocation: location)
 bottomLeftTile.color = .red
 ```

 Use the `neighbouringTiles` property to get a `Tile`s neighboring tiles.

 You can create new `TileLocation` objects either by using the `init(row: Int, column: Int)` initializer or by using the `advanced(by: Int, inDirection: Direction)` function

 Please note that, due to the way Swift Playgrounds works, extensive use of the `print` function will show down your algorithm by a lot.


 */
//#-hidden-code

// **TODOPerformance decrease due to enabled logging?**

import PlaygroundSupport

var _playGameCalled = false

/// Starts the Battleship game.
func playGame() {
    _playGameCalled = true
}

//#-end-hidden-code
//#-editable-code

func findPath(startTile: Tile, endTile: Tile) -> [TileLocation] {
    guard let maze = startTile.mazeScene else { return [] }

    return []
}

playGame()
//#-end-editable-code

//#-hidden-code
if _playGameCalled {
    let viewController = GameViewController()
    viewController.algorithm = .custom(findPath)
    viewController.hints = ["Try comparing different neighboring tiles based on their distance to the destination."]
    PlaygroundPage.current.liveView = viewController
}
//#-end-hidden-code
