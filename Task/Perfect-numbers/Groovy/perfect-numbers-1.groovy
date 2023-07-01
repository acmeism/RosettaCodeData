def isPerfect = { n ->
    n > 4 && (n == (2..Math.sqrt(n)).findAll { n % it == 0 }.inject(1) { factorSum, i -> factorSum += i + n/i })
}
