fun jacobi(A: Int, N: Int): Int {
    assert(N > 0 && N and 1 == 1)
    var a = A % N
    var n = N
    var result = 1
    while (a != 0) {
        var aMod4 = a and 3
        while (aMod4 == 0) {    // remove factors of four
            a = a shr 2
            aMod4 = a and 3
        }
        if (aMod4 == 2) {       // if even
            a = a shr 1         // remove factor 2 and possibly change sign
            if ((n and 7).let { it == 3 || it == 5 })
                result = -result
            aMod4 = a and 3
        }
        if (aMod4 == 3 && n and 3 == 3)
            result = -result
        a = (n % a).also { n = a }
    }
    return if (n == 1) result else 0
}
