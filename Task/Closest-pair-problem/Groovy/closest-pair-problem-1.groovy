class Point {
    final Number x, y
    Point(Number x = 0, Number y = 0) { this.x = x; this.y = y }
    Number distance(Point that) { ((this.x - that.x)**2 + (this.y - that.y)**2)**0.5 }
    String toString() { "{x:${x}, y:${y}}" }
}
