import Foundation

protocol Thingable { // prior to Swift 1.2, needs to be declared @objc
  func thing() -> String
}

class Delegator {
  weak var delegate: AnyObject?
  func operation() -> String {
    if let f = self.delegate?.thing {
      return f()
    } else {
      return "default implementation"
    }
  }
}

class Delegate {
  dynamic func thing() -> String { return "delegate implementation" }
}

// Without a delegate:
let a = Delegator()
println(a.operation())    // prints "default implementation"

// With a delegate that does not implement thing:
a.delegate = "A delegate may be any object"
println(a.operation())    // prints "default implementation"

// With a delegate that implements "thing":
let d = Delegate()
a.delegate = d
println(a.operation())    // prints "delegate implementation"
