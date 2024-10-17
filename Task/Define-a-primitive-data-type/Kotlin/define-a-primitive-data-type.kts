// version 1.1

class TinyInt(i: Int) {
    private val value = makeTiny(i)

    operator fun plus (other: TinyInt): TinyInt = TinyInt(this.value + other.value)
    operator fun minus(other: TinyInt): TinyInt = TinyInt(this.value - other.value)
    operator fun times(other: TinyInt): TinyInt = TinyInt(this.value * other.value)
    operator fun div  (other: TinyInt): TinyInt = TinyInt(this.value / other.value)
    operator fun rem  (other: TinyInt): TinyInt = TinyInt(this.value % other.value)

    operator fun inc()  = TinyInt(this.value + 1)
    operator fun dec()  = TinyInt(this.value - 1)

    private fun makeTiny(i: Int): Int =
        when {
            i < 1  -> 1
            i > 10 -> 10
            else   -> i
        }

    override fun toString(): String = value.toString()
}

fun main(args: Array<String>) {
    var t1 = TinyInt(6)
    var t2 = TinyInt(3)
    println("t1      = $t1")
    println("t2      = $t2")
    println("t1 + t2 = ${t1 + t2}")
    println("t1 - t2 = ${t1 - t2}")
    println("t1 * t2 = ${t1 * t2}")
    println("t1 / t2 = ${t1 / t2}")
    println("t1 % t2 = ${t1 % t2}")
    println("t1 + 1  = ${++t1}")
    println("t2 - 1  = ${--t2}")
}
