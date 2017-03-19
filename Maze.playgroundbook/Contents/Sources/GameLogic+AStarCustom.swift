import Foundation

extension TileLocation {
    func costToMove(to: TileLocation) -> Int { return 1 }
}


extension GameLogic {
    static func findAStarCustom(from: Tile, to: Tile) -> [TileLocation] {
        guard let maze = from.mazeScene else { return [] }

        var closedSteps = Set<ShortestPathStep>()
        var openSteps = [ShortestPathStep(position: from.location)]

        while !openSteps.isEmpty {
            let currentStep = openSteps.remove(at: 0)
            closedSteps.insert(currentStep)

            if currentStep.position == to.location {
                return convertStepsToShortestPath(lastStep: currentStep)
            }

            let neighboringLocations = maze.tile(atLocation: currentStep.position).neighbouringTiles.filter { maze.tile(atLocation: $0).state == .path }
            for location in neighboringLocations {
                var step = ShortestPathStep(position: location)
                if closedSteps.contains(step) {
                    continue
                }
                let moveCost = currentStep.position.costToMove(to: step.position)

                if let existingIndex = openSteps.index(of: step) {
                    var step = openSteps[existingIndex]
                    if currentStep.gScore + moveCost < step.gScore {
                        step.setParent(currentStep, withMoveCost: moveCost)

                        openSteps.remove(at: existingIndex)
                        insert(step: step, in: &openSteps)
                    }
                } else {
                    step.setParent(currentStep, withMoveCost: moveCost)
                    step.hScore = hScore(from: step.position, to: to.location)
                    insert(step: step, in: &openSteps)
                }
            }
        }
        return []
    }

    private static func insert(step: ShortestPathStep, in: inout [ShortestPathStep]) {
        `in`.append(step)
        `in`.sort { $0.fScore <= $1.fScore }
    }

    static func hScore(from: TileLocation, to: TileLocation) -> Int {
        return abs(to.column - from.column) + abs(to.row - from.row)
    }

    private static func convertStepsToShortestPath(lastStep: ShortestPathStep) -> [TileLocation] {
        var shortestPath = [TileLocation]()
        var currentStep = lastStep
        while let parent = currentStep.parent {
            shortestPath.insert(currentStep.position, at: 0)
            currentStep = parent.value
        }
        return shortestPath
    }
}

struct ShortestPathStep: Hashable {
    let position: TileLocation
    var parent: Indirect<ShortestPathStep>?

    var gScore = 0
    var hScore = 0
    var fScore: Int {
        return gScore + hScore
    }

    var hashValue: Int {
        return position.column.hashValue + position.row.hashValue
    }

    init(position: TileLocation) {
        self.position = position
    }

    mutating func setParent(_ parent: ShortestPathStep, withMoveCost: Int) {
        self.parent = Indirect<ShortestPathStep>(parent)
        self.gScore = parent.gScore + withMoveCost
    }
}

func ==(lhs: ShortestPathStep, rhs: ShortestPathStep) -> Bool {
    return lhs.position == rhs.position
}
