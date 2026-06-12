// version 1.1.51

class Point(val x: Int, val y: Int) : Comparable<Point> {
    fun rotate90()  = Point( this.y, -this.x)
    fun rotate180() = Point(-this.x, -this.y)
    fun rotate270() = Point(-this.y,  this.x)
    fun reflect()   = Point(-this.x,  this.y)

    override fun equals(other: Any?): Boolean {
        if (other == null || other !is Point) return false
        return this.x == other.x && this.y == other.y
    }

    override fun compareTo(other: Point) =
        if (this == other ) 0
        else if (this.x < other.x || (this.x == other.x && this.y < other.y)) -1
        else 1

    override fun toString() = "($x, $y)"
}

typealias Polyomino = List<Point>

// Finds the min x and y coordinates of a Polyomino.
val Polyomino.minima get() = Pair(this.minBy { it.x }!!.x, this.minBy { it.y }!!.y)

fun Polyomino.translateToOrigin(): Polyomino {
    val (minX, minY) = this.minima
    return this.map { Point(it.x - minX, it.y - minY) }.sorted()
}

// All the plane symmetries of a rectangular region.
val Polyomino.rotationsAndReflections get() =
    listOf(
        this,
        this.map { it.rotate90() },
        this.map { it.rotate180() },
        this.map { it.rotate270() },
        this.map { it.reflect() },
        this.map { it.rotate90().reflect() },
        this.map { it.rotate180().reflect() },
        this.map { it.rotate270().reflect() }
    )

val Polyomino.canonical get() =
    this.rotationsAndReflections.map { it.translateToOrigin() }.minBy { it.toString() }!!

// All four points in Von Neumann neighborhood
val Point.contiguous get() =
    listOf(Point(x - 1, y), Point(x + 1, y), Point(x, y - 1), Point(x, y + 1))

// Finds all distinct points that can be added to a Polyomino.
val Polyomino.newPoints get() = this.flatMap { it.contiguous }.filter { it !in this }.distinct()

val Polyomino.newPolys get() = this.newPoints.map { (this + it).canonical }

val monomino = listOf(Point(0, 0))
val monominoes = listOf(monomino)

// Generates polyominoes of rank n recursively.
fun rank(n: Int): List<Polyomino> = when {
    n < 0  -> throw IllegalArgumentException("n cannot be negative")
    n == 0 -> emptyList<Polyomino>()
    n == 1 -> monominoes
    else   -> rank(n - 1).flatMap { it.newPolys }
                         .distinctBy { it.toString() }
                         .sortedBy { it.toString() }
}

fun main(args: Array<String>) {
    val n = 5
    println("All free polyominoes of rank $n:\n")
    for (poly in rank(n)) {
        for (pt in poly) print("$pt ")
        println()
    }
    val k = 10
    println("\nNumber of free polyominoes of ranks 1 to $k:")
    for (i in 1..k) print("${rank(i).size} ")
    println()
}
