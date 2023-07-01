def makePoint(x, y) {
  def point implements pbc {
    to __printOn(out) { out.print(`<point $x,$y>`) }
    to __optUncall() { return [makePoint, "run", [x, y]] }
    to x() { return x }
    to y() { return y }
    to withX(new) { return makePoint(new, y) }
    to withY(new) { return makePoint(x, new) }
  }
  return point
}

def makeCircle(x, y, r) {
  def circle extends makePoint(x, y) implements pbc {
    to __printOn(out) { out.print(`<circle $x,$y r $r>`) }
    to __optUncall() { return [makeCircle, "run", [x, y, r]] }
    to r() { return r }
    to withX(new) { return makeCircle(new, y, r) }
    to withY(new) { return makeCircle(x, new, r) }
    to withR(new) { return makeCircle(x, y, new) }
  }
  return circle
}
