// version 1.1.3

interface Ring<T> {
    operator fun plus(other: Ring<T>): Ring<T>
    operator fun times(other: Ring<T>): Ring<T>
    val value: Int
    val one: Ring<T>
}

fun <T> Ring<T>.pow(p: Int): Ring<T> {
    require(p >= 0)
    var pp = p
    var pwr = this.one
    while (pp-- > 0) pwr *= this
    return pwr
}

class ModInt(override val value: Int, val modulo: Int): Ring<ModInt> {

    override operator fun plus(other: Ring<ModInt>): ModInt {
        require(other is ModInt &&  modulo == other.modulo)
        return ModInt((value + other.value) % modulo, modulo)
    }

    override operator fun times(other: Ring<ModInt>): ModInt {
        require(other is ModInt && modulo == other.modulo)
        return ModInt((value * other.value) % modulo, modulo)
    }

    override val one get() = ModInt(1, modulo)

    override fun toString() = "ModInt($value, $modulo)"
}

fun <T> f(x: Ring<T>): Ring<T> = x.pow(100) + x + x.one

fun main(args: Array<String>) {
    val x = ModInt(10, 13)
    val y = f(x)
    println("x ^ 100 + x + 1 for x == ModInt(10, 13) is $y")
}
