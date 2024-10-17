type NFib{T<:Integer}
    n::T
    klim::T
    seeder::Function
end

type FState
    a::Array{BigInt,1}
    adex::Integer
    k::Integer
end

function Base.start{T<:Integer}(nf::NFib{T})
    a = nf.seeder(nf.n)
    adex = 1
    k = 1
    return FState(a, adex, k)
end

function Base.done{T<:Integer}(nf::NFib{T}, fs::FState)
    fs.k > nf.klim
end

function Base.next{T<:Integer}(nf::NFib{T}, fs::FState)
    f = sum(fs.a)
    fs.a[fs.adex] = f
    fs.adex = rem1(fs.adex+1, nf.n)
    fs.k += 1
    return (f, fs)
end
