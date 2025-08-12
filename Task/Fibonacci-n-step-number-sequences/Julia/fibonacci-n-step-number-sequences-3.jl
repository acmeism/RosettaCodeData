function fib(n::Integer)
    a = zeros(BigInt, n)
    a[1] = one(BigInt)
    NFib(a, n)
end
