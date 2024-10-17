println("<math>")
println("\\begin{array}{lcl}")
for i in 0:10
    println(stringpoly(i))
end
println("\\end{array}")
println("</math>\n")

L = 50
print("AKS primes less than ", L, ":  ")
sep = ""
for i in 1:L
    if isaksprime(i)
        print(sep, i)
        sep = ", "
    end
end
println()
