using DataStructures
using Plots

struct SquareSums end

function Base.iterate(ss::SquareSums, state = (1, PriorityQueue{Tuple{Int, Int, Int}, Int}()))
    i, sums = state
    while isempty(sums) || i^2 <= peek(sums)[2]
        enqueue!(sums, (i^2, i, 0) => i^2)
        i += 1
    end
    nextsum, xy = peek(sums)[2], Tuple{Int, Int}[]
    while !isempty(sums) && peek(sums)[2] == nextsum # pop all vectors with same length
        nextsum, a, b = dequeue!(sums)
        push!(xy, (a, b))
        if a > b
            hsq = a^2 + (b + 1)^2
            enqueue!(sums, (hsq, a, b + 1) => hsq)
        end
    end
    return xy, (i, sums)
end

function babylonian_spiral(N)
    dx, dy, points = 0, 1, [(0, 0)]
    for xys in SquareSums()
        for i in 1:length(xys)
            a, b = xys[i]
            a != b && push!(xys, (b, a))
            a != 0 && push!(xys, (-a, b), (b, -a))
            b != 0 && push!(xys, (a, -b), (-b, a))
            a * b != 0 && push!(xys, (-a, -b), (-b, -a))
        end
        filter!(p -> p[1] * dy - p[2] * dx >= 0, xys)
        _, idx = findmax(p -> p[1] * dx + p[2] * dy, xys)
        dx, dy = xys[idx]
        push!(points, (points[end][1] + dx, points[end][2] + dy))
        length(points) >= N && break
    end
    return @view points[begin:N]
end

println("The first 40 Babylonian spiral points are:")
for (i, p) in enumerate(babylonian_spiral(40))
    print(rpad(p, 10), i % 10 == 0 ? "\n" : "")
end

Plots.plot(babylonian_spiral(10_000))
