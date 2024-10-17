// version 1.1.2

open class Point(var x: Int, var y: Int) {
    constructor(): this(0, 0)

    constructor(x: Int) : this(x, 0)

    constructor(p: Point) : this(p.x, p.y)

    open protected fun finalize() = println("Finalizing $this...")

    override fun toString() = "Point at ($x, $y)"

    open fun print() = println(this)
}

class Circle(x: Int, y: Int, var r: Int) : Point(x, y) {
    constructor(): this(0, 0, 0)

    constructor(x: Int) : this(x, 0, 0)

    constructor(x: Int, r: Int) : this(x, 0, r)

    constructor(c: Circle) : this(c.x, c.y, c.r)

    // for simplicity not calling super.finalize() below though this would normally be done in practice
    override protected fun finalize() = println("Finalizing $this...")

    override fun toString() = "Circle at center ($x, $y), radius $r"

    override fun print() = println(this)
}

fun createObjects() {
    val points = listOf(Point(), Point(1), Point(2, 3), Point(Point(3, 4)))
    for (point in points) point.print()
    val circles = listOf(Circle(), Circle(1), Circle(2, 3), Circle(4, 5, 6), Circle(Circle(7, 8, 9)))
    for (circle in circles) circle.print()
    println()
}

fun main(args: Array<String>) {
    createObjects()
    System.gc()  // try and force garbage collection
    Thread.sleep(2000) // allow time for finalizers to run
    println()
    val p = Point(5, 6)
    p.print()
    p.y = 7  // change y coordinate
    p.print()
    val c = Circle(5, 6, 7)
    c.print()
    c.r = 8
    c.print() // change radius
    /* note that finalizers for p and c are not called */
}
