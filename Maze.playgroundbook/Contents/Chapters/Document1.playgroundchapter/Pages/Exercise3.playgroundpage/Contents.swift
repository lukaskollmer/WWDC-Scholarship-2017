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
 **Goal:** In this exercise, you'll write code that gives the path between two tiles using the A* algorithm.

 Your A*-Algorithm should look at each tile in the maze and assign a value to it, it's so called weight.
 A Tile's weight is equal to the distance between that tile and the initial tile, plus the distance between that tile and the destination tile.

 Similar to the previous exercise, you should use the built-in `PathStep` struct to store individual steps of your path. When you reach the destination tile, the `PathStep.path` array contains the entire path from the initial tile to the destination. (This works by walking backwards through the `PathStep.parent` tree).

 _Please note that due to the way Swift Playgrounds works, extensive use of the `print` function will slow down your algorithm a lot._

 */
//#-hidden-code

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

    return []
}

solveMaze(.custom(findPath))
//#-end-editable-code
