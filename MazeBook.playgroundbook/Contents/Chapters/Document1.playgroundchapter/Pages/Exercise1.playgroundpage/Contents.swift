//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Lukas Kollmer. All Rights Reserved.
//
//#-end-hidden-code
/*:

 **About pathfinding algorithms**

 A pathfinding algorithm describes a method that searches a graph by starting at a given point and looking at all neighboring points until the destination is reached.

 There are different pathfinding methods:
 - [Breadth-first search](glossary://Breadth-first%20search) works by starting at the root and exploring all neighbor nodes first, before moving to the next level neighbors
 - [Dijkstra's algorithm](glossary://Dijkstra's%20algorithm) which, given a node will find the path between that node and all other nodes, therefore finding the shortest path between two nodes
 - A* is an extension of Dijkstra's algorithm that uses heuristics to improve performance ans is widely used in games **TODO** where else used?

 **About this Playground**

 The GameplayKit framework already includes a pathfinding API, which uses a version of the A* algorithm.

 In this initial example, you can select two tiles on the maze to gather some sample data on the performance of the included A* algorithm.

 Tap the _Run 100x_ button to gather a larger sample size.
 As you can see, the A* implementation in GameplayKit is incredibly fast, finding a path through the maze usually takes less than a millisecond, depending on the complexity of the maze.

 In the next chapter, you'll be tasked with writing your own pathfinding algorithm. The final chapter contains an example implementation of the A* pathfinding algorithm.


 */
//#-hidden-code
//#-code-completion(everything, hide)

import PlaygroundSupport

var _playGameCalled = false

func playGame() {
    _playGameCalled = true
}

//#-end-hidden-code
//#-editable-code

playGame()
//#-end-editable-code
//#-hidden-code

if _playGameCalled {
    let viewController = GameViewController()
    viewController.algorithm = .A_star
    PlaygroundPage.current.liveView = viewController
}

//#-end-hidden-code
