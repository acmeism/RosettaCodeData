using Primes

function bous!(triangle, k, n, seq)
    n == 1 && return BigInt(seq[k])
    triangle[k][n] > 0 && return triangle[k][n]
    return (triangle[k][n] = bous!(triangle, k, n - 1, seq) + bous!(triangle, k - 1, k - n + 1, seq))
end

boustrophedon(seq) = (n = length(seq); t = [zeros(BigInt, j) for j in 1:n]; [bous!(t, i, i, seq) for i in 1:n])
boustrophedon(f, range) = boustrophedon(map(f, range))

fib(n) = (z = BigInt(0); ccall((:__gmpz_fib_ui, :libgmp), Cvoid, (Ref{BigInt}, Culong), z, n); z)

tests = [
    ((n) -> n < 2, 1:1000, "One followed by an infinite series of zeros -> A000111"),
    ((n) -> 1, 1:1000, "An infinite series of ones -> A000667"),
    ((n) -> isodd(n) ? 1 : -1, 1:1000, "(-1)^n: alternating 1, -1, 1, -1 -> A062162"),
    ((n) -> prime(n), 1:1000, "Sequence of prime numbers -> A000747"),
    ((n) -> fib(n), 1:1000, "Sequence of Fibonacci numbers -> A000744"),
    ((n) -> factorial(BigInt(n)), 0:999, "Sequence of factorial numbers -> A230960")
]

for (f, rang, label) in tests
    println(label)
    arr = boustrophedon(f, rang)
    println(Int64.(arr[1:15]))
    s = string(arr[1000])
    println(s[1:20], " ... ", s[end-19:end], " ($(length(s)) digits)\n")
end
