immutable Spiral
    m::Int
    n::Int
    cmax::Int
    dir::Array{Array{Int,1},1}
    bdelta::Array{Array{Int,1},1}
end

function Spiral(m::Int, n::Int)
    cmax = m*n
    dir = Array{Int,1}[[0,1], [1,0], [0,-1], [-1,0]]
    bdelta = Array{Int,1}[[0,0,0,1], [-1,0,0,0],
                          [0,-1,0,0], [0,0,1,0]]
    Spiral(m, n, cmax, dir, bdelta)
end

function spiral(m::Int, n::Int)
    0<m&&0<n || error("The matrix dimensions must be positive.")
    Spiral(m, n)
end
spiral(n::Int) = spiral(n, n)

type SpState
    cnt::Int
    dirdex::Int
    cell::Array{Int,1}
    bounds::Array{Int,1}
end

Base.length(sp::Spiral) = sp.cmax
Base.start(sp::Spiral) = SpState(1, 1, [1,1], [sp.n,sp.m,1,1])
Base.done(sp::Spiral, sps::SpState) = sps.cnt > sp.cmax

function Base.next(sp::Spiral, sps::SpState)
    s = sub2ind((sp.m, sp.n), sps.cell[1], sps.cell[2])
    if sps.cell[rem1(sps.dirdex+1, 2)] == sps.bounds[sps.dirdex]
        sps.bounds += sp.bdelta[sps.dirdex]
        sps.dirdex = rem1(sps.dirdex+1, 4)
    end
    sps.cell += sp.dir[sps.dirdex]
    sps.cnt += 1
    return (s, sps)
end
