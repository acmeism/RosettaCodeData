def factorial = { x ->
    assert x > -1
    x == 0 ? 1 : (1..x).inject(1G) { BigInteger product, BigInteger factor -> product *= factor }
}

def combinations = { n, k ->
    assert k >= 0
    assert n >= k
    factorial(n).intdiv(factorial(k)*factorial(n-k))
}
