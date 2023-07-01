immutable ZigZag
    m::Int
    n::Int
    diag::Array{Int,1}
    cmax::Int
    numd::Int
    lohi::(Int,Int)
end

function zigzag(m::Int, n::Int)
    0<m && 0<n || error("The matrix dimensions must be positive.")
    ZigZag(m, n, [-1,1], m*n, m+n-1, extrema([m,n]))
end
zigzag(n::Int) = zigzag(n, n)

type ZZState
    cnt::Int
    cell::Array{Int,1}
    dir::Int
    dnum::Int
    dlen::Int
    dcnt::Int
end

Base.length(zz::ZigZag) = zz.cmax
Base.start(zz::ZigZag) = ZZState(1, [1,1], 1, 1, 1, 1)
Base.done(zz::ZigZag, zzs::ZZState) = zzs.cnt > zz.cmax

function Base.next(zz::ZigZag, zzs::ZZState)
    s = sub2ind((zz.m, zz.n), zzs.cell[1], zzs.cell[2])
    if zzs.dcnt == zzs.dlen
        if isodd(zzs.dnum)
            if zzs.cell[2] < zz.n
                zzs.cell[2] += 1
            else
                zzs.cell[1] += 1
            end
        else
            if zzs.cell[1] < zz.m
                zzs.cell[1] += 1
            else
                zzs.cell[2] += 1
            end
        end
        zzs.dcnt = 1
        zzs.dnum += 1
        zzs.dir = -zzs.dir
        if zzs.dnum <= zz.lohi[1]
            zzs.dlen += 1
        elseif zz.lohi[2] < zzs.dnum
            zzs.dlen -= 1
        end
    else
        zzs.cell += zzs.dir*zz.diag
        zzs.dcnt += 1
    end
    zzs.cnt += 1
    return (s, zzs)
end
