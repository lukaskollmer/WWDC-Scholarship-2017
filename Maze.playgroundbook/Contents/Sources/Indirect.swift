import Foundation

private final class IndirectWrapper<T> {
    var value : T

    init(_ value: T) {
        self.value = value
    }
}

public struct Indirect<T> {
    private var wrapper : IndirectWrapper<T>

    public init(_ value: T) {
        wrapper = IndirectWrapper(value)
    }

    public var value : T {
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