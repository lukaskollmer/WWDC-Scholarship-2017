import Foundation


public struct GameLogic {
    public typealias AlgorithmFunction = (Tile, Tile) -> [TileLocation]

    public enum Algorithm {
    case stupid
        case A_star
        case A_star_custom
        case custom(AlgorithmFunction)
    }

    public struct PathAlgoritmResult {
        public let path: [TileLocation]
        public let duration: TimeInterval
    }


    public static func findPath(from: Tile, to: Tile, using: Algorithm) -> PathAlgoritmResult {
        var path = [TileLocation]()
        let startTimestamp = Date()

        switch using {
        case .stupid:
            path = GameLogic.findPathStupid(from: from, to: to)
        case .A_star:
            path = GameLogic.findAStar(from: from, to: to)
        case .A_star_custom:
            path = GameLogic.findAStarCustom(from: from, to: to)
        case .custom(let algorithm):
            path = algorithm(from, to)
        }

        let duration = Date().timeIntervalSince(startTimestamp)
        return PathAlgoritmResult(path: path, duration: duration)
    }

}

