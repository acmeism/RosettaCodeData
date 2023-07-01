function fib_seeder{T<:Integer}(n::T)
    a = zeros(BigInt, n)
    a[1] = one(BigInt)
    return a
end

function fib{T<:Integer}(n::T, k::T)
    NFib(n, k, fib_seeder)
end
