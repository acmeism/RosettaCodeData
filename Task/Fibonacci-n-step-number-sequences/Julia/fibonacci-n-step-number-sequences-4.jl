function luc_seeder{T<:Integer}(n::T)
    a = -ones(BigInt, n)
    a[end] = big(n)
    return a
end

function luc{T<:Integer}(n::T, k::T)
    NFib(n, k, luc_seeder)
end
