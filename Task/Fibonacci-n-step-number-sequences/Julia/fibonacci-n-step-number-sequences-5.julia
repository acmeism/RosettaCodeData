lo = 2
hi = 10
klim = 16

print("n-step Fibonacci for n = (", lo, ",", hi)
println(") up to k = ", klim, ":")
for i in 2:10
    print(@sprintf("%5d => ", i))
    for j in fib(i, klim)
        print(j, " ")
    end
    println()
end

println()
print("n-step Rosetta Code Lucas for n = (", lo, ",", hi)
println(") up to k = ", klim, ":")
for i in 2:10
    print(@sprintf("%5d => ", i))
    for j in luc_rc(i, klim)
        print(j, " ")
    end
    println()
end

println()
print("n-step MathWorld Lucas for n = (", lo, ",", hi)
println(") up to k = ", klim, ":")
for i in 2:10
    print(@sprintf("%5d => ", i))
    for j in luc(i, klim)
        print(j, " ")
    end
    println()
end
