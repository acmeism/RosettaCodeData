function luc_rc(n::Integer)
    a = zeros(BigInt, n)
    a[1] = 3
    a[2] = -1
    NFib(a, n)
end
