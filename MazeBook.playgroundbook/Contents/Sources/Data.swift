import Foundation
import GameplayKit

public struct MazeData {
    public let numberOfRows: Int
    public let numberOfColumns: Int
    public let data: [[TileState]]

    public let gridGraph: GKGridGraph<GKGridGraphNode>

    public static func random(withSize: Int = 17) -> MazeData {
        return randomMaze(dimensions: withSize)
    }
}

