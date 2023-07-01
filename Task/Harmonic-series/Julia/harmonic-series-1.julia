const memoizer = [BigFloat(1.0), BigFloat(1.5)]

"""
    harmonic(n::Integer)::BigFloat
Calculates harmonic numbers. The integer argument `n` should be positive.
"""
function harmonic(n::Integer)::BigFloat
    if n < 0
        throw(DomainError(n))
    elseif n == 0
        return BigFloat(0.0)   # by convention
    elseif length(memoizer) >= n
        return memoizer[n]
    elseif length(memoizer) + 1 == n
        h = memoizer[end] + BigFloat(1.0) / n
        push!(memoizer, h)
        return h
    elseif n < 1_000_000
        start, x = length(memoizer), memoizer[end]
        for i in start+1:n
            push!(memoizer, (x += big"1.0" / i))
        end
        return memoizer[end]
    else
        # use H(n) = eulergamma + digamma(n + 1), instead, if memory use of memoization too large
        x = n + big"1.0"
        digam = BigFloat()
        ccall((:mpfr_digamma, :libmpfr), Int32, (Ref{BigFloat}, Ref{BigFloat}, Int32), digam, x, 1)
        return Base.MathConstants.eulergamma + digam
    end
end

function testharmonics(upperlimit = 11)
    n = 1
    while (h = harmonic(n)) < upperlimit
        nextintegerfloor = h < 1.8 ? h > 1.0 : floor(h) > floor(memoizer[n - 1])
        if n < 21 || nextintegerfloor
            println("harmonic($n) = $h")
            nextintegerfloor && println("    $n is also the term number for the first harmonic > $(floor(h))")
        end
        n += 1
    end
end

testharmonics()
