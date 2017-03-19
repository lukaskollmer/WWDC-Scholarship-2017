import Foundation
import UIKit
import SpriteKit

public class MazeView : SKView {
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
