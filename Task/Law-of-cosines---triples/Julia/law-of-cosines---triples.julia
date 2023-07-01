sqdict(n) = Dict([(x*x, x) for x in 1:n])
numnotsame(arrarr) = sum(map(x -> !all(y -> y == x[1], x), arrarr))

function filtertriangles(N)
    sqd = sqdict(N)
    t60 = Vector{Vector{Int}}()
    t90 = Vector{Vector{Int}}()
    t120 = Vector{Vector{Int}}()
    for x in 1:N, y in 1:x
        xsq, ysq, xy = (x*x, y*y, x*y)
        if haskey(sqd, xsq + ysq - xy)
            push!(t60, sort([x, y, sqd[xsq + ysq - xy]]))
        elseif haskey(sqd, xsq + ysq)
            push!(t90, sort([x, y, sqd[xsq + ysq]]))
        elseif haskey(sqd, xsq + ysq + xy)
            push!(t120, sort([x, y, sqd[xsq + ysq + xy]]))
        end
    end
    t60, t90, t120
end

tri60, tri90, tri120 = filtertriangles(13)
println("Integer triples for 1 <= side length <= 13:\n")
println("Angle 60:"); for t in tri60 println(t) end
println("Angle 90:"); for t in tri90 println(t) end
println("Angle 120:"); for t in tri120 println(t) end
println("\nFor sizes N through 10000, there are $(numnotsame(filtertriangles(10000)[1])) 60 degree triples with nonequal sides.")
