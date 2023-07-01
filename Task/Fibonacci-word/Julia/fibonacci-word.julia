using DataStructures
entropy(s::AbstractString) = -sum(x -> x / length(s) * log2(x / length(s)), values(counter(s)))

function fibboword(n::Int64)
    # Initialize the result
    r = Array{String}(n)
    # First element
    r[1] = "0"
    # If more than 2, set the second element
    if n ≥ 2 r[2] = "1" end
    # Recursively create elements > 3
    for i in 3:n
        r[i] = r[i - 1] * r[i - 2]
    end
    return r
end

function testfibbo(n::Integer)
    fib = fibboword(n)
    for i in 1:length(fib)
        @printf("%3d%9d%12.6f\n", i, length(fib[i]), entropy(fib[i]))
    end
    return 0
end

println("  n\tlength\tentropy")
testfibbo(37)
