//
//  MazeGenerator.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation
import GameplayKit
import SpriteKit

fileprivate struct Maze {

    let dimensions: Int
    let graph: GKGridGraph<GKGridGraphNode>
    let startNode: GKGridGraphNode
    let endNode: GKGridGraphNode

    init(dimensions: Int) {
        self.dimensions = dimensions
        self.graph = GKGridGraph<GKGridGraphNode>(fromGridStartingAt: int2(0, 0), width: Int32(dimensions), height: Int32(dimensions), diagonalsAllowed: false)

        self.startNode = graph.node(atGridPosition: int2(0, Int32(dimensions - 1)))!
        self.endNode = graph.node(atGridPosition: int2(Int32(dimensions - 1), 0))!

        var mazeBuilder = MazeBuilder(maze: self)

        let wallsForRemoval = mazeBuilder.mazeWallsForRemoval()

        self.graph.remove(wallsForRemoval)

    }
}


public func randomMaze(dimensions: Int) -> MazeData {
    let maze = Maze(dimensions: dimensions)

    guard let nodes = maze.graph.nodes else { fatalError("something went wrong. TODO remove this & return an optional") }
    var pathLocations = [TileLocation]()

    for node in nodes {
        if let gridNode = node as? GKGridGraphNode {
            let row = gridNode.gridPosition.x
            let column = gridNode.gridPosition.y
            pathLocations.append(TileLocation(row: Int(row), column: Int(column)))
        }
    }

    var mazeData = createEmptyMaze(withDimensions: dimensions)

    for pathTile in pathLocations {
        mazeData[pathTile.row][pathTile.column] = .path
    }

    return MazeData(numberOfRows: dimensions, numberOfColumns: dimensions, data: mazeData, gridGraph: maze.graph)
}


fileprivate func createEmptyMaze(withDimensions: Int) -> [[TileState]] {
    var empty = [[TileState]]()

    for _ in 0..<withDimensions {
        var emptyRow = [TileState]()
        for _ in 0..<withDimensions {
            emptyRow.append(.wall)
        }
        empty.append(emptyRow)
    }

    return empty
}


extension Direction {
    static func random() -> Direction {
        let randomInt = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        return Direction(rawValue: randomInt)!
    }

    var xOffset: Int {
        switch self {
        case .up, .down: return 0
        case .left:      return -2
        case .right:     return 2
        }
    }

    var yOffset: Int {
        switch self {
        case .left, .right: return 0
        case .up:           return 2
        case .down:         return -2
        }

    }
}


fileprivate struct MazeBuilder {
    private let maze: Maze

    private var walls = [GKGridGraphNode]()
    private var stack = [GKGridGraphNode]()
    private var visited = [GKGridGraphNode]()


    fileprivate init(maze: Maze) {
        self.maze = maze
    }


    private func potentialWalls() -> [GKGridGraphNode] {
        let graphNodes = maze.graph.nodes as! [GKGridGraphNode]

        let potentialWalls = graphNodes.filter { node in
            let x = Int(node.gridPosition.x)
            let y = Int(node.gridPosition.y)

            // Check for odd coordinates
            return x % 2 == 1 || y % 2 == 1
        }

        return potentialWalls
    }


    mutating func mazeWallsForRemoval() -> [GKGridGraphNode] {
        walls += potentialWalls()

        stack.append(maze.startNode)
        visited.append(maze.startNode)

        while let topNode = stack.last {
            guard nodeHasUnvisitedHeighbors(topNode) else {
                stack.removeLast()

                continue
            }

            exploreUnvisitedNodes: while true {
                let randomDirection = Direction.random()

                if shouldExplore(fromNode: topNode, inDirection: randomDirection) {
                    explore(fromNode: topNode, inDirection: randomDirection)
                    break exploreUnvisitedNodes
                }
            }
        }

        return walls
    }

    func shouldExplore(fromNode: GKGridGraphNode, inDirection: Direction) -> Bool {
        let dx = inDirection.xOffset
        let dy = inDirection.yOffset

        let x = fromNode.gridPosition.x
        let y = fromNode.gridPosition.y

        return didVisitNode(atCoordinates: x + dx, y: y + dy)
    }

    mutating func explore(fromNode: GKGridGraphNode, inDirection: Direction) {
        let dx = inDirection.xOffset
        let dy = inDirection.yOffset

        let x = fromNode.gridPosition.x
        let y = fromNode.gridPosition.y

        let nodeInDirectionPosition = int2(x + dx, y + dy)
        let nodeInDirection = maze.graph.node(atGridPosition: nodeInDirectionPosition)!

        stack.append(nodeInDirection)
        visited.append(nodeInDirection)

        let wallNodePosition = int2(x + dx / 2, y + dy / 2)
        let wallNode = maze.graph.node(atGridPosition: wallNodePosition)!
        let wallNodeIndex = walls.index(of: wallNode)!
        walls.remove(at: wallNodeIndex)
    }


    func nodeHasUnvisitedHeighbors(_ node: GKGridGraphNode) -> Bool {
        let x = node.gridPosition.x
        let y = node.gridPosition.y

        let leftNodeIsUnvisited   = didVisitNode(atCoordinates: x - 2, y: y)
        let rightNodeIsUnvisited  = didVisitNode(atCoordinates: x + 2, y: y)
        let topNodeIsUnvisited    = didVisitNode(atCoordinates: x, y: y + 2)
        let bottomNodeIsUnvisited = didVisitNode(atCoordinates: x, y: y - 2)

        return any(leftNodeIsUnvisited, rightNodeIsUnvisited, topNodeIsUnvisited, bottomNodeIsUnvisited)
    }


    func didVisitNode(atCoordinates x: Int32, y: Int32) -> Bool {
        let nodePosition = int2(x, y)
        guard let node = maze.graph.node(atGridPosition: nodePosition) else {
            return false
        }

        return !visited.contains(node)
    }
}

/**
 Check if any of the passed elements is true.
 For regular objects, this will check whether the object is nonnull
 For Bools, it will check if the bool is `true`

 (Should behave similar to Python's any function)
 */
func any<T: Equatable>(_ items: T?...) -> Bool {
    for item in items {
        if (item != nil) {
            guard item is Bool else { return true }
            if (item as! Bool) == true {
                return true
            }
        }
    }
    return false
}
