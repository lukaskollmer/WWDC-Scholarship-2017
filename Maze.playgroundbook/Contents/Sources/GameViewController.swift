//
//  GameViewController.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import UIKit
import SpriteKit
import PlaygroundSupport


let ColorChangeDuration: TimeInterval = 0.1


public class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public enum GameViewControllerMode {
        case introduction
        case maze
    }

    public let mode: GameViewControllerMode

    public var algorithm: GameLogic.Algorithm = .A_star

    public var successMessage: String?
    public var hints: [String]?
    public var solution: String?

    let mazeView = MazeView(frame: CGRect(x: 20, y: 20, width: 400, height: 400))

    let resetButton = UIButton(type: UIButtonType.roundedRect)
    let run100TimesButton = UIButton(type: UIButtonType.roundedRect)

    let run100TimesProgressBar = UIProgressView()
    let run100TimesProgressLabel = UILabel()

    let titleLabel = UILabel()
    let messageLabel = UILabel()

    let introductionMessageLabel = UILabel()

    let statsTableView = UITableView(frame: .zero, style: .plain)

    private var isRunning100TimesTest = false

    private var pathNode: SKShapeNode?

    private var durationStats = [String : String]() {
        didSet {
            self.statsTableView.reloadData()
        }
    }

    var startTile: Tile?
    var endTile: Tile?

    public init(mode: GameViewControllerMode) {
        self.mode = mode

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        super.loadView()

        //
        // UI
        //

        titleLabel.text = "Maze"
        titleLabel.font = .boldSystemFont(ofSize: 25)

        messageLabel.text = "by Lukas Kollmer"

        introductionMessageLabel.text = "Tap Run My Code to start"
        introductionMessageLabel.textColor = .introductionMessage
        introductionMessageLabel.font = .systemFont(ofSize: 24)
        introductionMessageLabel.textAlignment = .center
        introductionMessageLabel.numberOfLines = 0

        [resetButton, run100TimesButton].forEach {
            $0.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .gray
            $0.layer.cornerRadius = 5

        }

        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetMaze), for: .touchUpInside)

        run100TimesButton.setTitle("Run 100x", for: .normal)
        run100TimesButton.addTarget(self, action: #selector(run100Times), for: .touchUpInside)

        [run100TimesButton, run100TimesProgressBar, run100TimesProgressLabel].forEach {
            $0.isHidden = true
        }

        run100TimesProgressBar.frame = CGRect(x: 0, y: 0, width: 250, height: 10)
        run100TimesProgressLabel.textAlignment = .center

        statsTableView.dataSource = self
        statsTableView.delegate = self

        setupAutoLayout()

        [mazeView, statsTableView, titleLabel, messageLabel, run100TimesButton, run100TimesProgressBar, run100TimesProgressLabel, resetButton, introductionMessageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }

        if self.mode == .introduction {
            [mazeView, statsTableView, run100TimesButton, resetButton, run100TimesProgressBar, run100TimesProgressLabel].forEach {
                $0.removeFromSuperview()
            }
            //self.introductionMessageLabel.translatesAutoresizingMaskIntoConstraints = false
            //self.view.addSubview(self.introductionMessageLabel)
        } else {
            introductionMessageLabel.removeFromSuperview()
            registerTileTapHandler()
        }

    }

    @objc private func resetMaze() {
        let resetColorAction = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: ColorChangeDuration)
        [startTile, endTile].forEach { $0?.run(resetColorAction) }

        NotificationCenter.default.post(name: .resetAllTiles, object: nil)

        startTile = nil
        endTile = nil

        pathNode?.removeFromParent()

        self.durationStats = [:]
        self.isRunning100TimesTest = false
        self.run100TimesButton.isHidden = true
    }

    @objc private func run100Times() {
        // Check if Tiles are selected and make sure that we aren't already running a 100x test
        guard let start = self.startTile, let end = self.endTile else { return }
        guard !self.isRunning100TimesTest else { return }

        // TODO use this instead of changing all 3 propertioes in 3 differenr places
        //func updateUIForIsRunning100xTest(_ isRunning: Bool) {
        //
        //}

        // Update the UI
        self.mazeView.isHidden = true
        self.run100TimesProgressBar.isHidden = false
        self.run100TimesProgressLabel.isHidden = false

        self.durationStats = [:]
        var results: [GameLogic.PathAlgoritmResult] = []

        self.isRunning100TimesTest = true

        // Gather results
        DispatchQueue.global(qos: .background).async {
            for i in 1...100 {
                guard self.isRunning100TimesTest else {
                    DispatchQueue.main.async {
                        self.isRunning100TimesTest = false
                        self.mazeView.isHidden = false
                        self.run100TimesProgressBar.isHidden = true
                        self.run100TimesProgressLabel.isHidden = true
                    }
                    break
                }

                let result = GameLogic.findPath(from: start, to: end, using: self.algorithm)
                results.append(result)
                DispatchQueue.main.async {
                    self.run100TimesProgressBar.progress = Float(i) / Float(100)
                    self.run100TimesProgressLabel.text = "Running \(i) of 100"
                }

                if i == 100 {
                    DispatchQueue.main.async {
                        self.isRunning100TimesTest = false
                        self.mazeView.isHidden = false
                        self.run100TimesProgressBar.isHidden = true
                        self.run100TimesProgressLabel.isHidden = true

                        let durations = results
                            .map { $0.duration }
                            .sorted()
                        let averageDuration = durations.average

                        self.durationStats["Average"] = Utilities.string(fromTimeInterval: averageDuration)
                        self.durationStats["Minimum"] = Utilities.string(fromTimeInterval: durations.first!)
                        self.durationStats["Maximum"] = Utilities.string(fromTimeInterval: durations.last!)
                    }
                }
            }
        }
    }

    private func registerTileTapHandler() {
        // TODO Register observer and remove in deinit
        NotificationCenter.default.addObserver(forName: .didTapTile, object: nil, queue: nil) { notification in
            guard let selectedTile = notification.userInfo?["tile"] as? Tile else { return }

            // Only allow selection of path tiles
            guard selectedTile.state == .path else { return }

            // Can't go to the same tile
            guard self.startTile?.location != selectedTile.location else { return }
            var tileColor: UIColor = .white

            setTiles: do {
                if self.startTile == nil {
                    self.startTile = selectedTile
                    tileColor = .lightGray
                    break setTiles
                }

                if self.endTile == nil {
                    self.endTile = selectedTile
                    tileColor = .white
                    break setTiles
                }
            }

            let colorize = SKAction.colorize(with: tileColor, colorBlendFactor: 1, duration: ColorChangeDuration)
            selectedTile.run(colorize)

            if let start = self.startTile, let end = self.endTile {
                self.run100TimesButton.isHidden = false

                let pathResult = GameLogic.findPath(from: start, to: end, using: self.algorithm)

                if pathResult.path.isEmpty, let hints = self.hints {
                    PlaygroundPage.current.assessmentStatus = .fail(hints: hints, solution: self.solution)
                } // TODO implement else (.success)

                self.durationStats["Duration"] = Utilities.string(fromTimeInterval: pathResult.duration)


                let path = UIBezierPath()
                path.move(to: start.center)
                for location in pathResult.path {
                    if let tile = start.mazeScene?.tile(atLocation: location) {
                        path.addLine(to: tile.center)
                    }
                }

                self.pathNode = SKShapeNode(path: path.cgPath)
                self.pathNode?.lineWidth = 5
                self.pathNode?.strokeColor = .red
                start.mazeScene?.grid.addChild(self.pathNode!)

                let resetColor = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: ColorChangeDuration)
                start.run(resetColor)
                end.run(resetColor)
            }
        }
    }

    // MARK: Stats Table view

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.durationStats.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        cell.textLabel?.text = self.durationStats.allKeys[indexPath.row]
        cell.detailTextLabel?.text = self.durationStats.allValues[indexPath.row]

        cell.selectionStyle = .none

        return cell
    }

    public  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard isRunning100TimesTest else { return nil }

        return "Duration"
    }


    // MARK: Auto Layout

    private func setupAutoLayout() {

        let mazeViewConstraints = [
            // TODO make sure resizing to full screen doesn't make the maze too big
            NSLayoutConstraint(item: mazeView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 50.0),
            NSLayoutConstraint(item: mazeView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -50.0),
            NSLayoutConstraint(item: mazeView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 80.0),
            NSLayoutConstraint(item: mazeView, attribute: .height, relatedBy: .equal, toItem: mazeView, attribute: .width, multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: mazeView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 580.0),
        ]


        let buttonConstraints = [
            NSLayoutConstraint(item: resetButton, attribute: .trailing, relatedBy: .equal, toItem: mazeView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: resetButton, attribute: .centerY, relatedBy: .equal, toItem: messageLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: resetButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0),

            NSLayoutConstraint(item: run100TimesButton, attribute: .trailing, relatedBy: .equal, toItem: resetButton, attribute: .leading, multiplier: 1.0, constant: -10.0),
            NSLayoutConstraint(item: run100TimesButton, attribute: .centerY, relatedBy: .equal, toItem: messageLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: run100TimesButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0),
        ]

        let titleLabelConstraints = [
            NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 50.0),
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0),
            NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0),
        ]

        let messageLabelConstraints = [
            NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: mazeView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(item: messageLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0),
        ]

        let run100TimesProgressBarConstraints = [
            NSLayoutConstraint(item: run100TimesProgressBar, attribute: .leading, relatedBy: .equal, toItem: mazeView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: run100TimesProgressBar, attribute: .trailing, relatedBy: .equal, toItem: mazeView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: run100TimesProgressBar, attribute: .centerY, relatedBy: .equal, toItem: mazeView, attribute: .centerY, multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: run100TimesProgressLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0),
            NSLayoutConstraint(item: run100TimesProgressLabel, attribute: .leading, relatedBy: .equal, toItem: run100TimesProgressBar, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: run100TimesProgressLabel, attribute: .trailing, relatedBy: .equal, toItem: run100TimesProgressBar, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: run100TimesProgressLabel, attribute: .top, relatedBy: .equal, toItem: run100TimesProgressBar, attribute: .bottom, multiplier: 1.0, constant: 10.0),
        ]

        let tableViewConstraints = [
            NSLayoutConstraint(item: statsTableView, attribute: .leading, relatedBy: .equal, toItem: mazeView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: statsTableView, attribute: .trailing, relatedBy: .equal, toItem: mazeView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: statsTableView, attribute: .top, relatedBy: .equal, toItem: mazeView, attribute: .bottom, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(item: statsTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -20.0),
        ]

        let introductionMessageLabelConstraints = [
            NSLayoutConstraint(item: introductionMessageLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: introductionMessageLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: introductionMessageLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: introductionMessageLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ]

        view.addConstraints(mazeViewConstraints)
        view.addConstraints(buttonConstraints)
        view.addConstraints(titleLabelConstraints)
        view.addConstraints(messageLabelConstraints)
        view.addConstraints(run100TimesProgressBarConstraints)
        view.addConstraints(tableViewConstraints)
        view.addConstraints(introductionMessageLabelConstraints)
    }
}
