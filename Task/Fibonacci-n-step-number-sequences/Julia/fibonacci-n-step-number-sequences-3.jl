function luc_rc_seeder{T<:Integer}(n::T)
    a = zeros(BigInt, n)
    a[1] = 3
    a[2] = -1
    return a
end

function luc_rc{T<:Integer}(n::T, k::T)
    NFib(n, k, luc_rc_seeder)
end
