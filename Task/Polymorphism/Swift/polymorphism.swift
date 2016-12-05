class RCPoint : Printable {
  var x: Int
  var y: Int
  init(x: Int = 0, y: Int = 0) {
    self.x = x
    self.y = y
  }
  convenience init(p: RCPoint) {
    self.init(x:p.x, y:p.y)
  }
  var description: String {
  return "<RCPoint x: \(self.x) y: \(self.y)>"
  }
}

class RCCircle : RCPoint {
  var r: Int
  init(p: RCPoint, r: Int = 0) {
    self.r = r
    super.init(x:p.x, y:p.y)
  }
  init(x: Int = 0, y: Int = 0, r: Int = 0) {
    self.r = r
    super.init(x:x, y:y)
  }
  convenience init(c: RCCircle) {
    self.init(x:c.x, y:c.y, r:c.r)
  }
  override var description: String {
    return "<RCCircle x: \(x) y: \(y) r: \(r)>"
  }
}

println(RCPoint())
println(RCPoint(x:3))
println(RCPoint(x:3, y:4))
println(RCCircle())
println(RCCircle(x:3))
println(RCCircle(x:3, y:4))
println(RCCircle(x:3, y:4, r:7))
let p = RCPoint(x:1, y:2)
println(RCCircle(p:p))
println(RCCircle(p:p, r:7))
println(p.x) // 1
p.x = 8
println(p.x) // 8
