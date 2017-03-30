//
//  GameLogic.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation


/// General Game Logic
public struct GameLogic {
    /// A maze solving algorithm function (Takes two `Tile`s and returns an `[TileLocation]`
    public typealias AlgorithmFunction = (Tile, Tile) -> [TileLocation]

    /// A Maze solving algirithm
    ///
    /// - stupid: Please don't use this one
    /// - A_star: A*-Pathfinding algorithm
    /// - custom: A custom pathfinding algorithm. (This case has an associated value of type `AlgorithmFunction`
    public enum Algorithm {
        case stupid
        case A_star
        case custom(AlgorithmFunction)

        /// Check whether the Algorithm is a custom pathfinding function
        public var isCustom: Bool {
            switch self {
            case .stupid, .A_star:
                return false
            default:
                return true
            }
        }
    }

    /// A pathfinding result, containing both the path through the maze as well as the duration it took the algorithm to find that path
    public struct PathAlgoritmResult { //TODO Fix typo
        /// The path
        public let path: [TileLocation]
        
        
        /// The duration it took to find the path
        public let duration: TimeInterval
    }


    /// Fint the path between two tiles
    ///
    /// - Parameters:
    ///   - from: The start tile
    ///   - to: The end tile
    ///   - using: The pathfinding algorithm to be used
    /// - Returns: A `PathAlgoritmResult`
    public static func findPath(from: Tile, to: Tile, using: Algorithm) -> PathAlgoritmResult {
        var path = [TileLocation]()
        let startTimestamp = Date()

        switch using {
        case .stupid:
            path = GameLogic.findPathStupid(from: from, to: to)
        case .A_star:
            path = GameLogic.findAStar(from: from, to: to)
        case .custom(let algorithm):
            path = algorithm(from, to)
        }

        let duration = Date().timeIntervalSince(startTimestamp)
        return PathAlgoritmResult(path: path, duration: duration)
    }

}

