//
//  Tile.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation
import SpriteKit


/// A `Tile`s state (path or wall
public enum TileState: Int {
    case path
    case wall

    var color: UIColor {
        return self == .wall ? UIColor.black : UIColor.white
    }
}

/// A Tile node
public class Tile : SKSpriteNode {

    /// The tile's scene
    public weak var mazeScene: MazeScene?

    /// Current state of the tile
    public private(set) var state: TileState
    
    /// The Tile's location in the maze
    public let location: TileLocation

    private var notificationHandler: NSObjectProtocol?

    /// A Boolean determining whether the tile should show a dot which can be used for showing a path through a maze
    public var showPathIndicator: Bool = false {
        didSet {
            guard state == .path else { return } // You can't walk on walls...
            pathIndicator.isHidden = !showPathIndicator
        }
    }

    /// Tap handler
    var tapHandler: (() -> ())? = nil
    public let pathIndicator = SKShapeNode(circleOfRadius: 4)

    public override var size: CGSize {
        didSet {
            resizePaths()
        }
    }

    /// `Array<TileLocation>` of all neighboring tiles (only those who are actually valid in the maze)
    public var neighboringTiles: [TileLocation] {
        guard let maze = self.mazeScene?.maze else { return [] }

        return [
            location.advanced(by: 1, inDirection: .up),
            location.advanced(by: 1, inDirection: .down),
            location.advanced(by: 1, inDirection: .left),
            location.advanced(by: 1, inDirection: .right)
        ].filter {
            $0.isValid(inMaze: maze)
        }
    }

    /// Initialize a Tile at the specified location w/ the specified state
    ///
    /// - Parameters:
    ///   - location: `TileLocation`
    ///   - state: `TileState`
    init(location: TileLocation, state: TileState) {
        self.location = location
        self.state = state

        super.init(texture: nil, color: state.color, size: .zero)

        pathIndicator.lineWidth = 1
        pathIndicator.fillColor = .darkGray
        pathIndicator.isHidden = true
        self.addChild(pathIndicator)

        self.notificationHandler = NotificationCenter.default.addObserver(forName: .resetAllTiles, object: nil, queue: nil) { _ in
            self.showPathIndicator = false
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        if let handler = notificationHandler {
            NotificationCenter.default.removeObserver(handler)
        }
    }

    /// Update the state
    ///
    /// - Parameter state: <#state description#>
    public func setState(_ state: TileState) {
        self.state = state
        self.color = state.color
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        tapHandler?()
    }

    private func resizePaths() {
        pathIndicator.position = CGPoint(x: 0.5 * self.size.height, y: 0.5 * self.size.width)
    }
}

public func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs.location == rhs.location
}

