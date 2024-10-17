const N = 10
const GOAL = 10^6

function oneofn{T<:Integer}(n::T)
    0 < n || error("n = ", n, ", but it should be positive.")
    oon = 1
    for i in 2:n
        rand(1:i) == 1 || continue
        oon = i
    end
    return oon
end

nhist = zeros(Int, N)
for i in 1:GOAL
    nhist[oneofn(N)] += 1
end

println("Simulating oneofn(", N, ") ", GOAL, " times:")
for i in 1:N
    println(@sprintf "   %2d => %6d" i nhist[i])
end
