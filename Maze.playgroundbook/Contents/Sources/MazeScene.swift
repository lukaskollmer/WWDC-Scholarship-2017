//
//  MazeScene.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation
import UIKit
import SpriteKit
import GameplayKit

/// The SpriteKit scene drawing a maze
public class MazeScene : SKScene {

    /// Number of rows in the maze
    public let numberOfRows: Int
    
    /// Number of columns in the maze
    public let numberOfColumns: Int

    /// An array of all tiles, by row (you should use tile(atLocation:) or tile(atRow:column:) to get an individual tile
    private let tiles: [[Tile]]
    
    /// All tiles as a flat array
    public let allTiles: [Tile]
    
    /// An array of `GKGraphNode2D` objects representing all nodes in the maze
    public private(set) var allNodes = [GKGraphNode2D]()
    
    /// An array of `GKGraphNode2D` objects representing all path nodes in the maze
    public private(set) var allPathNodes = [GKGraphNode2D]()
    
    /// An array of `GKGraphNode2D` objects representing all wall nodes in the maze
    public private(set) var allWallNodes = [GKGraphNode2D]()

    /// The grid containing all tiles
    public let grid = SKNode()

    /// The maze's data
    public let maze: MazeData

    public override var size: CGSize {
        didSet {
            arrangeTiles()
        }
    }

    /// Initialize a MazeScene using the specified maze
    ///
    /// - Parameter maze: A `MazeData` object
    required public init(maze: MazeData) {
        self.maze = maze

        self.numberOfRows = maze.numberOfRows
        self.numberOfColumns = maze.numberOfColumns

        var tiles = [[Tile]]()
        var allTiles = [Tile]()

        for row in 0..<maze.numberOfRows {
            var tilesInRow = [Tile]()
            for column in  0..<maze.numberOfColumns {
                let location = TileLocation(row: row, column: column)
                let tile = Tile(location: location, state: .wall)

                tile.anchorPoint = .zero
                tile.isUserInteractionEnabled = true

                tile.tapHandler = {
                    NotificationCenter.default.post(name: .didTapTile, object: nil, userInfo: ["tile": tile])
                }

                tilesInRow.append(tile)
                allTiles.append(tile)
            }
            tiles.append(tilesInRow)
        }

        self.tiles = tiles
        self.allTiles = allTiles

        super.init(size: .zero)

        addChild(grid)

        self.tiles.joined().forEach { tile in
            tile.mazeScene = self
            tile.anchorPoint = .zero
            grid.addChild(tile)
        }

        load(maze: maze)

        self.backgroundColor = .clear

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override public func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        arrangeTiles()
    }
    

    /// Load a MazeData object into the maze
    ///
    /// - Parameter maze: MazeData
    private func load(maze: MazeData) {
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let tile = self.tile(atRow: row, column: column)
                let state = maze.data[abs(numberOfRows - (row + 1))][column]
                tile.setState(state)

                let node = GKGraphNode2D(point: vector_float2(x: Float(row), y: Float(column)))
                allNodes.append(node)
                switch state {
                case .wall:
                    allWallNodes.append(node)
                case .path:
                    allPathNodes.append(node)
                }

            }
        }
    }


    /// Utility function for getting a specific tile
    ///
    /// - Parameters:
    ///   - atRow: Row of the tile
    ///   - column: Column of the tile
    /// - Returns: `Tile`
    public func tile(atRow: Int, column: Int) -> Tile {
        return tile(atLocation: TileLocation(row: atRow, column: column))
    }

    /// Utility function for getting a specific tile
    ///
    /// - Parameter atLocation: `TileLocation` object describing the location of the tile you want to get
    /// - Returns: `Tile`
    public func tile(atLocation: TileLocation) -> Tile {
        return tiles[atLocation.row][atLocation.column]
    }

    /// Resize all tiles and the grid
    private func arrangeTiles() {
        // Calculate the size of the tiles so they're square and file in the space available.
        var totalGridDimension = min(size.height, size.width)
        let tileDimension = floor(totalGridDimension / CGFloat(numberOfRows))
        totalGridDimension = tileDimension * CGFloat(numberOfRows)

        // Position the grid anchor node at the bottom left of where the tiles should be placed.
        grid.position.x = (size.width / 2.0) - (totalGridDimension / 2.0)
        grid.position.y = size.height - totalGridDimension

        // Update the size and positions of the tiles.
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let tile = self.tile(atRow: row, column: column)

                tile.position = CGPoint(x: CGFloat(column) * tileDimension, y: CGFloat(row) * tileDimension)
                tile.size = CGSize(width: tileDimension, height: tileDimension)
            }
        }
    }
}


