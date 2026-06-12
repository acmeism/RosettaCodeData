let
    Y = (a) -> [((x) -> () -> x(Y(a)))(f) for f in a]

    even_odd_fix = [
        (f) -> (n) -> n == 0 || f[begin+1]()(n - 1),
        (f) -> (n) -> n != 0 && f[begin]()(n - 1),
    ]

    collatz_fix = [
        (f) -> (n, d) -> n == 1 ? d : f[isodd(n)+2]()(n, d + 1),
        (f) -> (n, d) -> f[begin]()(n ÷ 2, d),
        (f) -> (n, d) -> f[begin]()(3 * n + 1, d),
    ]

    evenodd = [f() for f in Y(even_odd_fix)]
    collatz = Y(collatz_fix)[begin]()

    for i = 1:10
        e = evenodd[begin](i)
        o = evenodd[begin+1](i)
        c = collatz(i, 0)
        println(lpad(i, 2), ": Even: $e  Odd: $o  Collatz: $c")
    end
end
