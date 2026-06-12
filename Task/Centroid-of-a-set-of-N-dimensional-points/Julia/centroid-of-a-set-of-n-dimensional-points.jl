using Plots

struct Point{T, N}
    v::Vector{T}
end

function centroid(points::Vector{Point{T, N}}) where N where T
    arr = zeros(T, N)
    for p in points, (i, x) in enumerate(p.v)
        arr[i] += x
    end
    return Point{T, N}(arr / length(points))
end

function centroid(arr)
    isempty(arr) && return Point{Float64, 0}(arr)
    n = length(arr[begin])
    t = typeof(arr[begin][begin])
    return centroid([Point{t, n}(v) for v in arr])
end

const testvecs = [[[1], [2], [3]],
                  [(8, 2), (0, 0)],
                  [[5, 5, 0], [10, 10, 0]],
                  [[1.0, 3.1, 6.5], [-2, -5, 3.4], [-7, -4, 9.0], [2.0, 0.0, 3.0],],
                  [[0, 0, 0, 0, 1], [0, 0, 0, 1, 0], [0, 0, 1, 0, 0], [0, 1, 0, 0, 0],],
                 ]

function test_centroids(tests)
    for t in tests
        isempty(t) && error("The empty set of points $t has no centroid")
        vvec = [Point{Float64, length(t[begin])}(collect(v)) for v in t]
        println("$t => $(centroid(vvec))")
    end
    xyz = [p[1] for p in tests[4]], [p[2] for p in tests[4]], [p[3] for p in tests[4]]
    cpoint = centroid(tests[4]).v
    for i in eachindex(cpoint)
        push!(xyz[i], cpoint[i])
    end
    scatter(xyz..., color = [:navy, :navy, :navy, :navy, :red], legend = :none)
end

test_centroids(testvecs)
