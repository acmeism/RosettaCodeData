using Printf

println("Some easy ones to start with\n")

for i in [-1:21..., 100, 101, 10000, 10001, 1000000, 1010101]
    @printf("%8d is %s\n", i, num2text(i))
end

println("\nSome larger numbers\n")

println("The largest signed literal integer (short-scale)")
i = typemax(1)
println("    ", i, " is")
println(num2text(i))
println()

println("The largest signed literal integer (long-scale)")
println("    ", i, " is")
println(num2text(i, false))
println()

println("The largest unsigned integer (short-scale)")
i = typemax(UInt128)
println("    ", i, " is")
println(num2text(i))
println()

println("50! (short-scale)")
i = factorial(big(50))
println("    ", i, " is")
println(num2text(i))
println()

println("51! (short-scale)")
i = factorial(big(51))
println("    ", i, " is")
println(num2text(i))
println()

println("51! (long-scale)")
println("    ", i, " is")
println(num2text(i, false))
