using Primes, Printf

function addmsdigit(p::Integer, b::Integer, s::Integer)
    a = Vector{typeof(p)}()
    q = p
    for i in 1:(b-1)
        q += s
        isprime(q) || continue
        push!(a, q)
    end
    return a
end

function lefttruncprime(pbase::Integer)
    a = Vector{BigInt}()
    append!(a, primes(pbase - 1))
    mlt = zero(BigInt)
    s = one(BigInt)
    while !isempty(a)
        mlt = maximum(a)
        s *= pbase
        for i in 1:length(a)
            p = popfirst!(a)
            append!(a, addmsdigit(p, pbase, s))
        end
    end
    return mlt
end

lo, hi = 3, 17
println("The largest left truncatable primes for bases", @sprintf(" %d to %d.", lo, hi))
for i in lo:hi
    mlt = lefttruncprime(i)
    @printf("%10d %-30d (%s)\n", i, mlt, string(mlt, base=i))
end
