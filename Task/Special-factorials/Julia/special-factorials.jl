superfactorial(n) = n < 1 ? 1 : mapreduce(factorial, *, 1:n)
sf(n) = superfactorial(n)

hyperfactorial(n) = n < 1 ? 1 : mapreduce(i -> i^i, *, 1:n)
H(n) = hyperfactorial(n)

alternating_factorial(n) = n < 1 ? 0 : mapreduce(i -> (-1)^(n - i) * factorial(i), +, 1:n)
af(n) = alternating_factorial(n)

exponential_factorial(n) = n < 1 ? 1 : foldl((x, y) -> y^x, 1:n)
n＄(n) = exponential_factorial(n)

function reverse_factorial(n)
    n == 1 && return 0
    fac = one(n)
    for i in 2:10000
        fac *= i
        fac == n && return i
        fac > n && break
    end
    return nothing
end
rf(n) = reverse_factorial(n)

println("N  Superfactorial    Hyperfactorial", " "^18, "Alternating Factorial   Exponential Factorial\n", "-"^98)
for n in 0:9
    print(n, "  ")
    for f in [sf, H, af, n＄]
        if n < 5 || f != n＄
            print(rpad(f(Int128(n)), f == H ? 37 : 24))
        end
    end
    println()
end

println("\nThe number of digits in n＄(5) is ", length(string(n＄(BigInt(5)))))

println("\n\nN  Reverse Factorial\n", "-"^25)
for n in [1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 119]
    println(rpad(n, 10), rf(n))
end
