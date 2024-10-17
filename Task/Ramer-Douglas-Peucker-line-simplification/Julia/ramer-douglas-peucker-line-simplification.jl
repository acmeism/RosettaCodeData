const Point = Vector{Float64}

function perpdist(pt::Point, lnstart::Point, lnend::Point)
    d = normalize!(lnend .- lnstart)

    pv = pt .- lnstart
    # Get dot product (project pv onto normalized direction)
    pvdot = dot(d, pv)
    # Scale line direction vector
    ds = pvdot .* d
    # Subtract this from pv
    return norm(pv .- ds)
end

function rdp(plist::Vector{Point}, ϵ::Float64 = 1.0)
    if length(plist) < 2
        throw(ArgumentError("not enough points to simplify"))
    end

    # Find the point with the maximum distance from line between start and end
    distances  = collect(perpdist(pt, plist[1], plist[end]) for pt in plist)
    dmax, imax = findmax(distances)

    # If max distance is greater than epsilon, recursively simplify
    if dmax > ϵ
        fstline = plist[1:imax]
        lstline = plist[imax:end]

        recrst1 = rdp(fstline, ϵ)
        recrst2 = rdp(lstline, ϵ)

        out = vcat(recrst1, recrst2)
    else
        out = [plist[1], plist[end]]
    end

    return out
end

plist = Point[[0.0, 0.0], [1.0, 0.1], [2.0, -0.1], [3.0, 5.0], [4.0, 6.0], [5.0, 7.0], [6.0, 8.1], [7.0, 9.0], [8.0, 9.0], [9.0, 9.0]]
@show plist
@show rdp(plist)
