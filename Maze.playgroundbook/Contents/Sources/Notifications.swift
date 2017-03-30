//
//  Notifications.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


import Foundation

public extension Notification.Name {
    /// Notification posted by a tile when it was tapped
    public static let didTapTile = Notification.Name("didTapTile")
    
    /// Notification sent to all tiles when they should reset themselves (eg remove any paths or selection colors)
    public static let resetAllTiles = Notification.Name("resetAllTiles")
}
