M = [rand(1:20) for i in 1:5, j in 1:10]
R, C = size(M)

println("The full matrix is:")
println(M, "\n")

println("Find the first 20:")
for i in 1:R, j in 1:C
    n = M[i,j]
    @printf "%4d" n
    if n == 20
        println()
        break
    elseif j == C
        println()
    end
end
