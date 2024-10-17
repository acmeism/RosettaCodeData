using Primes, Printf
function strfactor(n::Integer)
    n > -2 || return "-1 × " * strfactor(-n)
    isprime(n) || n < 2 && return dec(n)
    f = factor(Vector{typeof(n)}, n)
    return join(f, " × ")
end

lo, hi = -4, 40
println("Factor print $lo to $hi:")
for n in lo:hi
    @printf("%5d = %s\n", n, strfactor(n))
end
