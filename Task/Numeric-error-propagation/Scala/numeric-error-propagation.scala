import java.lang.Math._

class Approx(val ν: Double, val σ: Double = 0.0) {
    def this(a: Approx) = this(a.ν, a.σ)
    def this(n: Number) = this(n.doubleValue(), 0.0)

    override def toString = s"$ν ±$σ"

    def +(a: Approx) = Approx(ν + a.ν, sqrt(σ * σ + a.σ * a.σ))
    def +(d: Double) = Approx(ν + d, σ)
    def -(a: Approx) = Approx(ν - a.ν, sqrt(σ * σ + a.σ * a.σ))
    def -(d: Double) = Approx(ν - d, σ)

    def *(a: Approx) = {
        val v = ν * a.ν
        Approx(v, sqrt(v * v * σ * σ / (ν * ν) + a.σ * a.σ / (a.ν * a.ν)))
    }

    def *(d: Double) = Approx(ν * d, abs(d * σ))

    def /(a: Approx) = {
        val t = ν / a.ν
        Approx(t, sqrt(t * t * σ * σ / (ν * ν) + a.σ * a.σ / (a.ν * a.ν)))
    }

    def /(d: Double) = Approx(ν / d, abs(d * σ))

    def ^(d: Double) = {
        val t = pow(ν, d)
        Approx(t, abs(t * d * σ / ν))
    }
}

object Approx { def apply(ν: Double, σ: Double = 0.0) = new Approx(ν, σ) }

object NumericError extends App {
    def √(a: Approx) = a^0.5
    val x1 = Approx(100.0, 1.1)
    val x2 = Approx(50.0, 1.2)
    val y1 = Approx(200.0, 2.2)
    val y2 = Approx(100.0, 2.3)
    println(√(((x1 - x2)^2.0) + ((y1 - y2)^2.0)))  // => 111.80339887498948 ±2.938366893361004
}
