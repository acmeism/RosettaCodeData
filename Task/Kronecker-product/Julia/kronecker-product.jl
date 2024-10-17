# v0.6

# Julia has a builtin kronecker product function
a = [1 2; 3 4]
b = [0 5; 6 7]
k = kron(a, b)
println("$a × $b =")
for row in 1:size(k)[1]
    println(k[row,:])
end
println()

a = [0 1 0; 1 1 1; 0 1 0]
b = [1 1 1 1; 1 0 0 1; 1 1 1 1]
k = kron(a, b)
println("$a × $b =")
for row in 1:size(k)[1]
    println(k[row,:])
end
