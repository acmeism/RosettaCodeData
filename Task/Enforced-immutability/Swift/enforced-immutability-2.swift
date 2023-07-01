/// Value types are denoted by `struct`s
struct Point {
  var x: Int
  var y: Int
}

let p = Point(x: 1, y: 1)
p.x = 2 // error, because Point is a value type with an immutable variable

/// Reference types are denoted by `class`s
class ClassPoint {
  var x: Int
  var y: Int

  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

let pClass = ClassPoint(x: 1, y: 1)
pClass.x = 2 // Fine because reference types can be mutated, as long as you are not replacing the reference
