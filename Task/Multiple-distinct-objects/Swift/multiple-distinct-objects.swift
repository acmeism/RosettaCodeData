class Foo { }

var foos = [Foo]()
for i in 0..<n {
    foos.append(Foo())
}

// incorrect version:
var foos_WRONG = [Foo](count: n, repeatedValue: Foo())  // Foo() only evaluated once
