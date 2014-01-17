@Canonical
@TupleConstructor(force = true)
@ToString(includeNames = true)
class Point {
    Point(Point p) { x = p.x; y = p.y }
    void print() { println toString() }
    Number x
    Number y
}

@Canonical
@TupleConstructor(force = true)
@ToString(includeNames = true, includeSuper = true)
class Circle extends Point {
    Circle(Circle c) { super(c); r = c.r }
    void print() { println toString() }
    Number r
}
