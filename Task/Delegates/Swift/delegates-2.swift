protocol Thingable : class {
  func thing() -> String
}

class Delegator {
  weak var delegate: Thingable?
  func operation() -> String {
    if let d = self.delegate {
      return d.thing()
    } else {
      return "default implementation"
    }
  }
}

class Delegate : Thingable {
  func thing() -> String { return "delegate implementation" }
}

// Without a delegate:
let a = Delegator()
println(a.operation())    // prints "default implementation"

// With a delegate:
let d = Delegate()
a.delegate = d
println(a.operation())    // prints "delegate implementation"
