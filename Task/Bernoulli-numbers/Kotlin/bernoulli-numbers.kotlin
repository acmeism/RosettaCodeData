import org.apache.commons.math3.fraction.BigFraction

object Bernoulli {
    operator fun invoke(n: Int) : BigFraction {
        val A = Array(n + 1, init)
        for (m in 0..n)
            for (j in m downTo 1)
                A[j - 1] = A[j - 1].subtract(A[j]).multiply(integers[j])
        return A.first()
    }

    val max = 60

    private val init = { m: Int -> BigFraction(1, m + 1) }
    private val integers = Array(max + 1, { m: Int -> BigFraction(m) } )
}

fun main(args: Array<String>) {
    for (n in 0..Bernoulli.max)
        if (n % 2 == 0 || n == 1)
            System.out.printf("B(%-2d) = %-1s%n", n, Bernoulli(n))
}
