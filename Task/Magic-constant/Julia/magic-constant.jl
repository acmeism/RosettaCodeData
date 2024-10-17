using Lazy

magic(x) = (1 + x^2) * x ÷ 2
magics = @>> Lazy.range() map(magic) filter(x -> x > 10) # first 2 values are filtered out
println("First 20 magic constants: ", Int.(take(20, magics)))
println("Thousandth magic constant is: ", collect(take(1000, magics))[end])

println("Smallest magic square with constant greater than:")
for expo in 1:20
    goal = big"10"^expo
    ordr = Int(floor((2 * goal)^(1/3))) + 1
    println("10^", string(expo, pad=2), "    ", ordr)
end
