using Primes
function properdivisors(n::T) where {T<:Integer}
    0 < n || throw(ArgumentError("number to be factored must be ≥ 0, got $n"))
    1 < n || return T[]
    !isprime(n) || return T[one(T)]
    f = factor(n)
    d = T[one(T)]
    for (k, v) in f
        c = T[k^i for i in 0:v]
        d = d*c'
        d = reshape(d, length(d))
    end
    sort!(d)
    return d[1:end-1]
end

lo = 1
hi = 10
println("List the proper divisors for ", lo, " through ", hi, ".")
for i in lo:hi
    println(@sprintf("%4d", i), " ", properdivisors(i))
end

hi = 2*10^4
println("\nFind the numbers within [", lo, ",", hi, "] having the most divisors.")

maxdiv = 0
nlst = Int[]

for i in lo:hi
    ndiv = length(properdivisors(i))
    if ndiv > maxdiv
        maxdiv = ndiv
        nlst = [i]
    elseif ndiv == maxdiv
        push!(nlst, i)
    end
end

println(nlst, " have the maximum proper divisor count of ", maxdiv, ".")
