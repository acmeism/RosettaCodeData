function L(n, add::Int=1, firsts::Vector=[1, 1])
    l = max(maximum(n) .+ 1, length(firsts))
    r = Vector{Int}(l)
    r[1:length(firsts)] = firsts
    for i in 3:l
        r[i] = r[i - 1] + r[i - 2] + add
    end
    return r[n .+ 1]
end

# Task 1
println("First 25 Leonardo numbers: ", join(L(0:24), ", "))

# Task 2
@show L(0) L(1)

# Task 4
println("First 25 Leonardo numbers starting with [0, 1]: ", join(L(0:24, 0, [0, 1]), ", "))
