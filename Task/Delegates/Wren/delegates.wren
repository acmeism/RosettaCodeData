class Thingable {
    thing { }
}

// Delegate that doesn't implement Thingable
class Delegate {
    construct new() { }
}

// Delegate that implements Thingable
class Delegate2 is Thingable {
    construct new() { }

    thing { "delegate implementation" }
}

class Delegator {
    construct new() {
        _delegate = null
    }

    delegate     { _delegate }
    delegate=(d) { _delegate = d }

    operation {
        if (!_delegate || !(_delegate is Thingable)) return "default implementation"
        return _delegate.thing
    }
}

// without a delegate
var d = Delegator.new()
System.print(d.operation)

// with a delegate that doesn't implement Thingable
d.delegate = Delegate.new()
System.print(d.operation)

// with a delegate that does implement Thingable
d.delegate = Delegate2.new()
System.print(d.operation)
