function luc(n::Integer)
    a = -ones(BigInt, n)
    a[end] = big(n)
    NFib(a, n)
end
