function penalize!{T<:Integer,U<:String}(sd::Array{Array{Resource{T},1},1},
                                         tp::TProblem{T,U})
    avail = BitArray{1}[]
    for dim in 2:-1:1
        push!(avail, bitpack(map(isavailable, sd[dim])))
    end
    for dim in 1:2, r in sd[dim]
        if r.quant == 0
            r.l = r.m = r.p = r.q = 0
            continue
        end
        r.l == 0 || !avail[dim][r.l] || !avail[dim][r.m] || continue
        rsort = filter(x->avail[dim][x], vec(slicedim(tp.tsort[dim],dim,r.i)))
        rcost = vec(slicedim(tp.toc, dim, r.i))[rsort]
        if length(rsort) == 1
            r.l = r.m = rsort[1]
            r.p = r.q = rcost[1]
        else
            r.l, r.m = rsort[1:2]
            r.p = rcost[2] - rcost[1]
            r.q = rcost[1]
        end
    end
    nothing
end

function vogel{T<:Integer,U<:String}(tp::TProblem{T,U})
    sdcnt = collect(size(tp.toc))
    sol = spzeros(T, sdcnt[1], sdcnt[2])
    sd = Array{Resource{T},1}[]
    for dim in 1:2
        push!(sd, [Resource(dim, i, tp.sd[dim][i]) for i in 1:sdcnt[dim]])
    end
    while any(map(isavailable, sd[1])) && any(map(isavailable, sd[2]))
        penalize!(sd, tp)
        a = maximum([sd[1], sd[2]])
        b = sd[rem1(a.dim+1,2)][a.l]
        if a.dim == 2 # swap to make a supply and b demand
            a, b = b, a
        end
        expend = min(a.quant, b.quant)
        sol[a.i, b.i] = expend
        a.quant -= expend
        b.quant -= expend
    end
    return sol
end
