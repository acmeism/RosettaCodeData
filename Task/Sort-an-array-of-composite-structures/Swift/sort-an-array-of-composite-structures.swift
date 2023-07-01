extension Sequence {
  func sorted<Value>(
    on: KeyPath<Element, Value>,
    using: (Value, Value) -> Bool
  ) -> [Element] where Value: Comparable {
    return withoutActuallyEscaping(using, do: {using -> [Element] in
      return self.sorted(by: { using($0[keyPath: on], $1[keyPath: on]) })
    })
  }
}

struct Person {
  var name: String
  var role: String
}

let a = Person(name: "alice", role: "manager")
let b = Person(name: "bob", role: "worker")
let c = Person(name: "charlie", role: "driver")

print([c, b, a].sorted(on: \.name, using: <))
