import java.lang.Math.*

data class Approx(val ν: Double, val σ: Double = 0.0) {
    constructor(a: Approx) : this(a.ν, a.σ)
    constructor(n: Number) : this(n.toDouble(), 0.0)

    override fun toString() = "$ν ±$σ"

    operator infix fun plus(a: Approx) = Approx(ν + a.ν, sqrt(σ * σ + a.σ * a.σ))
    operator infix fun plus(d: Double) = Approx(ν + d, σ)
    operator infix fun minus(a: Approx) = Approx(ν - a.ν, sqrt(σ * σ + a.σ * a.σ))
    operator infix fun minus(d: Double) = Approx(ν - d, σ)

    operator infix fun times(a: Approx): Approx {
        val v = ν * a.ν
        return Approx(v, sqrt(v * v * σ * σ / (ν * ν) + a.σ * a.σ / (a.ν * a.ν)))
    }

    operator infix fun times(d: Double) = Approx(ν * d, abs(d * σ))

    operator infix fun div(a: Approx): Approx {
        val v = ν / a.ν
        return Approx(v, sqrt(v * v * σ * σ / (ν * ν) + a.σ * a.σ / (a.ν * a.ν)))
    }

    operator infix fun div(d: Double) = Approx(ν / d, abs(d * σ))

    fun pow(d: Double): Approx {
        val v = pow(ν, d)
        return Approx(v, abs(v * d * σ / ν))
    }
}

fun main(args: Array<String>) {
    val x1 = Approx(100.0, 1.1)
    val y1 = Approx(50.0, 1.2)
    val x2 = Approx(200.0, 2.2)
    val y2 = Approx(100.0, 2.3)
    println(((x1 - x2).pow(2.0) + (y1 - y2).pow(2.0)).pow(0.5))
}
