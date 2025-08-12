struct NFib
    seed::Vector{BigInt}
    n::Int
end
NFib(seed::AbstractVector{<:Integer}) = NFib(seed, length(seed))

mutable struct FState
    a::Vector{BigInt}
    adex::Int
end

function Base.iterate(nf::NFib, fs::FState=FState(copy(nf.seed), 1))
    f = sum(fs.a)
    fs.a[fs.adex] = f
    fs.adex = mod1(fs.adex + 1, nf.n)
    f, fs
end

Base.eltype(::NFib) = BigInt
Base.isdone(::NFib) = false
Base.isdone(::NFib, ::FState) = false
Base.IteratorSize(::NFib) = Base.IsInfinite()
