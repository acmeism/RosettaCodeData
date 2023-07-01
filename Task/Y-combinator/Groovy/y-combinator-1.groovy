def Y = { le -> ({ f -> f(f) })({ f -> le { x -> f(f)(x) } }) }

def factorial = Y { fac ->
    { n -> n <= 2 ? n : n * fac(n - 1) }
}

assert 2432902008176640000 == factorial(20G)

def fib = Y { fibStar ->
    { n -> n <= 1 ? n : fibStar(n - 1) + fibStar(n - 2) }
}

assert fib(10) == 55
