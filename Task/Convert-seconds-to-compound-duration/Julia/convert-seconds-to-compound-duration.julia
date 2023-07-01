# 1.x
function duration(sec::Integer)::String
    t = Array{Int}([])
    for dm in (60, 60, 24, 7)
        sec, m = divrem(sec, dm)
        pushfirst!(t, m)
    end
    pushfirst!(t, sec)
    return join(["$num$unit" for (num, unit) in zip(t, ["w", "d", "h", "m", "s"]) if num > 0], ", ")
end

@show duration(7259)
@show duration(86400)
@show duration(6000000)
