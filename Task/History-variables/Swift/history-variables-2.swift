struct History <T> {

    private var _history = [T]()
    var history : [T] {
        return _history
    }

    var now : T {
        return history.last!
    }

    init(_ firstValue:T) {
        _history = [firstValue]
    }

    mutating func set(newValue:T) {
        _history.append(newValue)
    }

    mutating func undo() -> T {
        guard _history.count > 1 else { return _history.first! }
        _history.removeLast()
        return _history.last!
    }
}

var h = History("First")
h.set("Next")
h.set("Then")
h.set("Finally")
h.history   // output ["First", "Next", "Then", "Finally"]

h.now       // outputs "Finally"
h.undo()    // outputs "Then"
h.undo()    // outputs "Next"
h.undo()    // outputs "First"
h.undo()    // outputs "First", since it can't roll back any further
h.undo()    // outputs "First"
