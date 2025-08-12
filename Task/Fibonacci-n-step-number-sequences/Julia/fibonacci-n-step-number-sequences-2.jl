function skip(xs::Vector{BigInt}, k::Integer, n::Integer)
    a = zeros(BigInt, (n, n))
    for i = 2:n
        a[i-1, i] = 1
    end
    a[n, :] .= 1
    a^k * xs
end

Base.getindex(nf::NFib, k::Integer)::BigInt =
    k < nf.n ? nf.seed[nf.n-k] : last(skip(nf.seed, k, nf.n))

function Base.getindex(nf::NFib, r::UnitRange{<:Integer})::Vector{BigInt}
    if iszero(r[1])
        [last(nf.seed), Iterators.take(nf, length(r) - 1)...]
    else
        [Iterators.take(Iterators.drop(nf, r[1] - 1), length(r))...]
    end
end

Iterators.drop(nf::NFib, k::Integer) =
    iszero(k) ? nf : NFib(skip(nf.seed, k, nf.n), nf.n)

Iterators.drop(take::Iterators.Take{NFib}, k::Integer) =
    Iterators.take(Iterators.drop(take.xs, k), max(0, take.n - k))
