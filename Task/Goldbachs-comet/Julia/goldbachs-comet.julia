using Combinatorics
using Plots
using Primes

g(n) = iseven(n) ? count(p -> all(isprime, p), partitions(n, 2)) : error("n must be even")

println("The first 100 G numbers are: ")

foreach(p -> print(lpad(p[2], 4), p[1] % 10 == 0 ? "\n" : ""), map(g, 4:2:202) |> enumerate)

println("\nThe value of G(1000000) is ", g(1_000_000))

x = collect(2:2002)
y = map(g, 2x)
scatter(x, y, markerstrokewidth = 0, color = ["red", "blue", "green"][mod1.(x, 3)])
