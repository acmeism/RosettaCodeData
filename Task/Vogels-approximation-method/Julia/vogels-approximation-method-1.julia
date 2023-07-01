immutable TProblem{T<:Integer,U<:String}
    sd::Array{Array{T,1},1}
    toc::Array{T,2}
    labels::Array{Array{U,1},1}
    tsort::Array{Array{T,2}, 1}
end

function TProblem{T<:Integer,U<:String}(s::Array{T,1},
                                        d::Array{T,1},
                                        toc::Array{T,2},
                                        slab::Array{U,1},
                                        dlab::Array{U,1})
    scnt = length(s)
    dcnt = length(d)
    size(toc) = (scnt,dcnt) || error("Supply, Demand, TOC Size Mismatch")
    length(slab) == scnt || error("Supply Label Size Labels")
    length(dlab) == dcnt || error("Demand Label Size Labels")
    0 <= minimum(s) || error("Negative Supply Value")
    0 <= minimum(d) || error("Negative Demand Value")
    sd = Array{T,1}[]
    push!(sd, s)
    push!(sd, d)
    labels = Array{U,1}[]
    push!(labels, slab)
    push!(labels, dlab)
    tsort = Array{T,2}[]
    push!(tsort, mapslices(sortperm, toc, 2))
    push!(tsort, mapslices(sortperm, toc, 1))
    TProblem(sd, toc, labels, tsort)
end
isbalanced(tp::TProblem) = sum(tp.sd[1]) == sum(tp.sd[2])

type Resource{T<:Integer}
    dim::T
    i::T
    quant::T
    l::T
    m::T
    p::T
    q::T
end
function Resource{T<:Integer}(dim::T, i::T, quant::T)
    zed = zero(T)
    Resource(dim, i, quant, zed, zed, zed, zed)
end

isavailable(r::Resource) = 0 < r.quant
Base.isless(a::Resource, b::Resource) = a.p < b.p || (a.p == b.p && b.q < a.q)
