using Printf
test = [7.125, [rand()*10^rand(0:4) for i in 1:9]]

println("Formatting some numbers with the @sprintf macro (using \"%09.3f\"):")
for i in test
    println(@sprintf "    %09.3f" i)
end

using Formatting
println()
println("The same thing using the Formatting package:")
fe = FormatExpr("    {1:09.3f}")
for i in test
    printfmtln(fe, i)
end
