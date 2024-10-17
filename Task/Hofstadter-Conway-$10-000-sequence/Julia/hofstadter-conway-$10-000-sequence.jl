# v0.6

# Task 1
function hofstadterconway(n::Integer)::Vector{Int}
    rst = fill(1, n)
    for i in 3:n
        rst[i] = rst[rst[i - 1]] + rst[i - rst[i - 1]]
    end
    return rst
end

function hcfraction(n::Integer)::Vector{Float64}
    rst = Array{Float64}(n)
    for (i, a) in enumerate(hofstadterconway(n))
        rst[i] = abs(a) / i
    end
    return rst
end

# Task 2
seq = hcfraction(2 ^ 20)
for i in 1:20
    a, b = 2 ^ (i - 1), 2 ^ i
    @printf("max value of a(n)/n in %6i < n < %7i = %5.3f\n", a, b, maximum(seq[a:b]))
end

# Task 3
function lastindex(val::Float64)
    r, p = 1, 0
    # Find the range of 2 power in which the maximum is < val
    seq = hcfraction(2 ^ 15)
    while maximum(seq[2^p:2^(p+1)]) > val; p += 1 end
    r = 2 ^ (p + 1)
    while seq[r] < val; r -= 1 end
    return r
end

println("You too might have won \$1000 with the mallows number of ", lastindex(0.55))
