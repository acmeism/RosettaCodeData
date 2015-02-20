def _fft(cSeq: Seq[Complex], direction: Complex, scalar: Int): Seq[Complex] = {
    if (cSeq.length == 1) {
        return cSeq
    }
    val n = cSeq.length
    assume(n % 2 == 0, "The Cooley-Tukey FFT algorithm only works when the length of the input is even.")

    val evenOddPairs = cSeq.grouped(2).toSeq
    val evens = _fft(evenOddPairs map (_(0)), direction, scalar)
    val odds  = _fft(evenOddPairs map (_(1)), direction, scalar)

    def leftRightPair(k: Int): Pair[Complex, Complex] = {
        val base = evens(k) / scalar
        val offset = exp(direction * (Pi * k / n)) * odds(k) / scalar
        (base + offset, base - offset)
    }

    val pairs = (0 until n/2) map leftRightPair
    val left  = pairs map (_._1)
    val right = pairs map (_._2)
    left ++ right
}

def  fft(cSeq: Seq[Complex]): Seq[Complex] = _fft(cSeq, Complex(0,  2), 1)
def rfft(cSeq: Seq[Complex]): Seq[Complex] = _fft(cSeq, Complex(0, -2), 2)
