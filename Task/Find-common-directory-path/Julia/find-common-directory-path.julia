function commonpath(ds::Vector{<:AbstractString}, dlm::Char='/')
    0 < length(ds) || return ""
    1 < length(ds) || return String(ds[1])
    p = split(ds[1], dlm)
    mincnt = length(p)
    for d in ds[2:end]
        q = split(d, dlm)
        mincnt = min(mincnt, length(q))
        hits = findfirst(p[1:mincnt] .!= q[1:mincnt])
        if hits != 0 mincnt = hits - 1 end
        if mincnt == 0 return "" end
    end
    1 < mincnt || p[1] != "" || return convert(T, string(dlm))
    return join(p[1:mincnt], dlm)
end

test = ["/home/user1/tmp/coverage/test", "/home/user1/tmp/covert/operator", "/home/user1/tmp/coven/members"]

println("Comparing:\n - ", join(test, "\n - "))
println("for their common directory path yields:\n", commonpath(test))
