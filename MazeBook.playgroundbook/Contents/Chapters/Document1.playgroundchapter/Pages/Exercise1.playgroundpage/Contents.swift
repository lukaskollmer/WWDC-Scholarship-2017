//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Lukas Kollmer. All Rights Reserved.
//
//#-end-hidden-code
/*:

 **Pathfinding algorithms**

 A pathfinding algorithm is a method that can find a path between two points in a graph.

 There are different pathfinding methods:
 - [Breadth-first search](glossary://Breadth-first%20search) works by starting at the root and exploring all neighbor nodes first, before moving to the next level neighbors
 - [Dijkstra's algorithm](glossary://Dijkstra's%20algorithm) which, given a node will find the path between that node and all other nodes, therefore finding the shortest path between two nodes
 - A* is an extension of Dijkstra's algorithm that uses heuristics to improve performance and is widely used in games

 **About this Playground**

 Tap two tiles in the maze to calculate a path between them. Tap the _Run 100x_ button to gather a larger sample size.

 This introduction page uses a pathfinding algorithm provided the GameplayKit framework.

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
