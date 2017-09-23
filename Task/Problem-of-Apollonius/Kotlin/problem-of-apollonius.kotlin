// version 1.1.3

data class Circle(val x: Double, val y: Double, val r: Double)

val Double.sq get() = this * this

fun solveApollonius(c1: Circle, c2: Circle, c3: Circle,
                    s1: Int, s2: Int, s3: Int): Circle {
    val (x1, y1, r1) = c1
    val (x2, y2, r2) = c2
    val (x3, y3, r3) = c3

    val v11 = 2 * x2 - 2 * x1
    val v12 = 2 * y2 - 2 * y1
    val v13 = x1.sq - x2.sq + y1.sq - y2.sq - r1.sq + r2.sq
    val v14 = 2 * s2 * r2 - 2 * s1 * r1

    val v21 = 2 * x3 - 2 * x2
    val v22 = 2 * y3 - 2 * y2
    val v23 = x2.sq - x3.sq + y2.sq - y3.sq - r2.sq + r3.sq
    val v24 = 2 * s3 * r3 - 2 * s2 * r2

    val w12 = v12 / v11
    val w13 = v13 / v11
    val w14 = v14 / v11

    val w22 = v22 / v21 - w12
    val w23 = v23 / v21 - w13
    val w24 = v24 / v21 - w14

    val p = -w23 / w22
    val q =  w24 / w22
    val m = -w12 * p - w13
    val n =  w14 - w12 * q

    val a = n.sq +  q.sq - 1
    val b = 2 * m * n - 2 * n * x1 + 2 * p * q - 2 * q * y1 + 2 * s1 * r1
    val c = x1.sq + m.sq - 2 * m * x1 + p.sq + y1.sq - 2 * p * y1 - r1.sq

    val d = b.sq - 4 * a * c
    val rs = (-b - Math.sqrt(d)) / (2 * a)
    val xs = m + n * rs
    val ys = p + q * rs
    return Circle(xs, ys, rs)
}

fun main(args: Array<String>) {
    val c1 = Circle(0.0, 0.0, 1.0)
    val c2 = Circle(4.0, 0.0, 1.0)
    val c3 = Circle(2.0, 4.0, 2.0)
    println(solveApollonius(c1, c2, c3, 1, 1, 1))
    println(solveApollonius(c1, c2, c3,-1,-1,-1))
}
