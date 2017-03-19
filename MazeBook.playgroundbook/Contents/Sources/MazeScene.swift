import Foundation
import UIKit
import SpriteKit
import GameplayKit

public class MazeScene : SKScene {

    public let numberOfRows: Int
    public let numberOfColumns: Int

    private let tiles: [[Tile]]
    public let allTiles: [Tile]
    public private(set) var allNodes = [GKGraphNode2D]()
    public private(set) var allPathNodes = [GKGraphNode2D]()
    public private(set) var allWallNodes = [GKGraphNode2D]()

    private let grid = SKNode()

    public let maze: MazeData

    public override var size: CGSize {
        didSet {
            arrangeTiles()
        }
    }

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

    public func load(maze: MazeData) {
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


    public func tile(atRow: Int, column: Int) -> Tile {
        return tile(atLocation: TileLocation(row: atRow, column: column))
    }

    public func tile(atLocation: TileLocation) -> Tile {
        return tiles[atLocation.row][atLocation.column]
    }

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


