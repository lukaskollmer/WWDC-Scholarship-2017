//
//  Indirect.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation



private final class IndirectWrapper<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}

/// A Wrapper around an object (so that for example a struct can have a member of its own type)
struct Indirect<T> {
    private var wrapper : IndirectWrapper<T>

    init(_ value: T) {
        wrapper = IndirectWrapper(value)
    }

    var value: T {
        get {
            return wrapper.value
        }
        set {
            if isKnownUniquelyReferenced(&wrapper) {
                wrapper.value = newValue
            } else {
                wrapper = IndirectWrapper(newValue)
            }
        }
    }
}
