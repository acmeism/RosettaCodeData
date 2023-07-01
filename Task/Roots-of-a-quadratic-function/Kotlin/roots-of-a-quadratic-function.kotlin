import java.lang.Math.*

data class Equation(val a: Double, val b: Double, val c: Double) {
    data class Complex(val r: Double, val i: Double) {
        override fun toString() = when {
            i == 0.0 -> r.toString()
            r == 0.0 -> "${i}i"
            else -> "$r + ${i}i"
        }
    }

    data class Solution(val x1: Any, val x2: Any) {
        override fun toString() = when(x1) {
            x2 -> "X1,2 = $x1"
            else -> "X1 = $x1, X2 = $x2"
        }
    }

    val quadraticRoots by lazy {
        val _2a = a + a
        val d = b * b - 4.0 * a * c  // discriminant
         if (d < 0.0) {
            val r = -b / _2a
            val i = sqrt(-d) / _2a
            Solution(Complex(r, i), Complex(r, -i))
        } else {
            // avoid calculating -b +/- sqrt(d), to avoid any
            // subtractive cancellation when it is near zero.
            val r = if (b < 0.0) (-b + sqrt(d)) / _2a else (-b - sqrt(d)) / _2a
            Solution(r, c / (a * r))
        }
    }
}

fun main(args: Array<String>) {
    val equations = listOf(Equation(1.0, 22.0, -1323.0),   // two distinct real roots
                           Equation(6.0, -23.0, 20.0),     //  with a != 1.0
                           Equation(1.0, -1.0e9, 1.0),     //  with one root near zero
                           Equation(1.0, 2.0, 1.0),        // one real root (double root)
                           Equation(1.0, 0.0, 1.0),        // two imaginary roots
                           Equation(1.0, 1.0, 1.0))        // two complex roots

    equations.forEach { println("$it\n" + it.quadraticRoots) }
}
