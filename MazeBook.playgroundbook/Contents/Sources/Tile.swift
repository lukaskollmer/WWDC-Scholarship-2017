import Foundation
import SpriteKit


public enum TileState: Int {
    case path
    case wall

    var color: UIColor {
        return self == .wall ? UIColor.black : UIColor.white
    }
}

public class Tile : SKSpriteNode {

    public weak var mazeScene: MazeScene?

    public private(set) var state: TileState
    public let location: TileLocation

    private var notificationHandler: NSObjectProtocol?

    public var showPathIndicator: Bool = false {
        didSet {
            guard state == .path else { return } // You can't walk on walls...
            pathIndicator.isHidden = !showPathIndicator
        }
    }

    var tapHandler: (() -> ())? = nil
    public let pathIndicator = SKShapeNode(circleOfRadius: 4)

    public override var size: CGSize {
        didSet {
            resizePaths()
        }
    }

    public var neighbouringTiles: [TileLocation] {
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

//extension Tile : Equatable { }

public func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs.location == rhs.location
}

