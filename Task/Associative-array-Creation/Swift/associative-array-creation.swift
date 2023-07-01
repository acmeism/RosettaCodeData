// make an empty map
var a = [String: Int]()
// or
var b: [String: Int] = [:]

// make an empty map with an initial capacity
var c = [String: Int](minimumCapacity: 42)

// set a value
c["foo"] = 3

// make a map with a literal
var d = ["foo": 2, "bar": 42, "baz": -1]
