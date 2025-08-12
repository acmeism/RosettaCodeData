using Printf: @printf

lo = 2
hi = 10
klim = 16

print("n-step Fibonacci for n = (", lo, ",", hi)
println(") up to k = ", klim, ":")
for i in 2:10
    @printf("%5d => ", i)
    for j in Iterators.take(fib(i), klim)
        print(j, " ")
    end
    println()
end
println("\nCalculated the 1000000th Fibonacci number in ", (@timed fib(2)[1_000_000]).time, " seconds\n")
print("n-step Rosetta Code Lucas for n = (", lo, ",", hi)
println(") up to k = ", klim, ":")
for i in 2:10
    @printf("%5d => ", i)
    for j in Iterators.take(luc_rc(i), klim)
        print(j, " ")
    end
    println()
end

println()
print("n-step MathWorld Lucas for n = (", lo, ",", hi)
println(") up to k = ", klim, ":")
for i in 2:10
    @printf("%5d => ", i)
    for j in Iterators.take(luc(i), klim)
        print(j, " ")
    end
    println()
end
