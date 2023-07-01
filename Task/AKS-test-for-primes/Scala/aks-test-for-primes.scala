def powerMin1(n: BigInt) = if (n % 2 == 0) BigInt(1) else BigInt(-1)

val pascal = (( Vector(Vector(BigInt(1))) /: (1 to 50)) { (rows, i) =>
    val v = rows.head
    val newVector = ((1 until v.length) map (j =>
        powerMin1(j+i) * (v(j-1).abs + v(j).abs))
    ).toVector
    (powerMin1(i) +: newVector :+ powerMin1(i+v.length)) +: rows
}).reverse

def poly2String(poly: Vector[BigInt]) = ((0 until poly.length) map { i =>
    (i, poly(i)) match {
        case (0, c) => c.toString
        case (_, c) =>
            (if (c >= 0) "+" else "-") +
            (if (c == 1) "x" else c.abs + "x") +
            (if (i == 1) "" else "^" + i)
    }
}) mkString ""

def isPrime(n: Int) = {
    val poly = pascal(n)
    poly.slice(1, poly.length - 1).forall(i => i % n == 0)
}

for(i <- 0 to 7) { println( f"(x-1)^$i = ${poly2String( pascal(i) )}" ) }

val primes = (2 to 50).filter(isPrime)
println
println(primes mkString " ")
