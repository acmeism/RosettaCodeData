n = 5
println("The n = ", n, " spiral matrix:")
a = zeros(Int, (n, n))
for (i, s) in enumerate(spiral(n))
    a[s] = i-1
end
println(pretty(a))

m = 3
println()
println("Generalize to a non-square matrix (", m, "x", n, "):")
a = zeros(Int, (m, n))
for (i, s) in enumerate(spiral(m, n))
    a[s] = i-1
end
println(pretty(a))

p = primes(10^3)
n = 7
println()
println("An n = ", n, " prime spiral matrix:")
a = zeros(Int, (n, n))
for (i, s) in enumerate(spiral(n))
    a[s] = p[i]
end
println(pretty(a))
