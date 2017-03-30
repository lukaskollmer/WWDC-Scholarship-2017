//
//  GameLogic+Stupid.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation

extension GameLogic {
    /// Please don't use this one
    ///
    /// - Parameters:
    ///   - from: Start Tile
    ///   - to: End Tile
    /// - Returns: `[TileLocation]`
    static func findPathStupid(from: Tile, to: Tile) -> [TileLocation] {
        guard let mazeScene = from.mazeScene else { return [] }

        var didFindTarget = false
        var currentTile = from
        var path = [from.location]

        while !didFindTarget {
            var possibleLocations = [TileLocation]()

            let loadPossibleLocations = {
                possibleLocations = currentTile.neighboringTiles
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

}
