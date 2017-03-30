//
//  MazeView.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation
import UIKit
import SpriteKit

/// The MazeView containing the scene which draws the maze
public class MazeView : SKView {
    /// The scene
    private let mazeScene: MazeScene

    public override var frame: CGRect {
        didSet {
            mazeScene.size = frame.size
        }
    }

    public override init(frame: CGRect) {

        let randomMaze = MazeData.random(withSize: 21)

        mazeScene = MazeScene(maze: randomMaze)
        mazeScene.size = frame.size

        super.init(frame: frame)

        presentScene(mazeScene)
        self.allowsTransparency = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
