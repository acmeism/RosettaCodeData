object FFT {
    fun fft(a: Array<Complex>) = _fft(a, Complex(0.0, 2.0), 1.0)
    fun rfft(a: Array<Complex>) = _fft(a, Complex(0.0, -2.0), 2.0)

    private fun _fft(a: Array<Complex>, direction: Complex, scalar: Double): Array<Complex> =
            if (a.size == 1)
                a
            else {
                val n = a.size
                require(n % 2 == 0, { "The Cooley-Tukey FFT algorithm only works when the length of the input is even." })

                var (evens, odds) = Pair(emptyArray<Complex>(), emptyArray<Complex>())
                for (i in a.indices)
                    if (i % 2 == 0) evens += a[i]
                    else odds += a[i]
                evens = _fft(evens, direction, scalar)
                odds = _fft(odds, direction, scalar)

                val pairs = (0 until n / 2).map {
                    val offset = (direction * (java.lang.Math.PI * it / n)).exp * odds[it] / scalar
                    val base = evens[it] / scalar
                    Pair(base + offset, base - offset)
                }
                var (left, right) = Pair(emptyArray<Complex>(), emptyArray<Complex>())
                for ((l, r) in pairs) { left += l; right += r }
                left + right
            }
}
