fun bitCount(i: Int): Int {
    var j = i
    j -= ((j shr 1) and 0x55555555)
    j = (j and 0x33333333) + ((j shr 2) and 0x33333333)
    j = (j + (j shr 4)) and 0x0F0F0F0F
    j += (j shr 8)
    j += (j shr 16)
    return j and 0x0000003F
}

fun reorderingSign(i: Int, j: Int): Double {
    var k = i shr 1
    var sum = 0
    while (k != 0) {
        sum += bitCount(k and j)
        k = k shr 1
    }
    return if (sum and 1 == 0) 1.0 else -1.0
}

class Vector(private val dims: DoubleArray) {

    infix fun dot(rhs: Vector): Vector {
        return (this * rhs + rhs * this) * 0.5
    }

    operator fun unaryMinus(): Vector {
        return this * -1.0
    }

    operator fun plus(rhs: Vector): Vector {
        val result = DoubleArray(32)
        dims.copyInto(result)
        for (i in 0 until rhs.dims.size) {
            result[i] += rhs[i]
        }
        return Vector(result)
    }

    operator fun times(rhs: Vector): Vector {
        val result = DoubleArray(32)
        for (i in 0 until dims.size) {
            if (dims[i] != 0.0) {
                for (j in 0 until rhs.dims.size) {
                    if (rhs[j] != 0.0) {
                        val s = reorderingSign(i, j) * dims[i] * rhs[j]
                        val k = i xor j
                        result[k] += s
                    }
                }
            }
        }
        return Vector(result)
    }

    operator fun times(scale: Double): Vector {
        val result = dims.clone()
        for (i in 0 until 5) {
            dims[i] = dims[i] * scale
        }
        return Vector(result)
    }

    operator fun get(index: Int): Double {
        return dims[index]
    }

    operator fun set(index: Int, value: Double) {
        dims[index] = value
    }

    override fun toString(): String {
        val sb = StringBuilder("(")
        val it = dims.iterator()
        if (it.hasNext()) {
            sb.append(it.next())
        }
        while (it.hasNext()) {
            sb.append(", ").append(it.next())
        }
        return sb.append(")").toString()
    }
}

fun e(n: Int): Vector {
    if (n > 4) {
        throw IllegalArgumentException("n must be less than 5")
    }
    val result = Vector(DoubleArray(32))
    result[1 shl n] = 1.0
    return result
}

val rand = java.util.Random()

fun randomVector(): Vector {
    var result = Vector(DoubleArray(32))
    for (i in 0 until 5) {
        result += Vector(doubleArrayOf(rand.nextDouble())) * e(i)
    }
    return result
}

fun randomMultiVector(): Vector {
    val result = Vector(DoubleArray(32))
    for (i in 0 until 32) {
        result[i] = rand.nextDouble()
    }
    return result
}

fun main() {
    for (i in 0..4) {
        for (j in 0..4) {
            if (i < j) {
                if ((e(i) dot e(j))[0] != 0.0) {
                    println("Unexpected non-null scalar product.")
                    return
                } else if (i == j) {
                    if ((e(i) dot e(j))[0] == 0.0) {
                        println("Unexpected null scalar product.")
                    }
                }
            }
        }
    }

    val a = randomMultiVector()
    val b = randomMultiVector()
    val c = randomMultiVector()
    val x = randomVector()

    // (ab)c == a(bc)
    println((a * b) * c)
    println(a * (b * c))
    println()

    // a(b+c) == ab + ac
    println(a * (b + c))
    println(a * b + a * c)
    println()

    // (a+b)c == ac + bc
    println((a + b) * c)
    println(a * c + b * c)
    println()

    // x^2 is real
    println(x * x)
}
