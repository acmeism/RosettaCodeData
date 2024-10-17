const Prime = UInt64

struct Primes
    rangei :: Int64
    primebits :: BitArray{1}
    function Primes(n :: Int64)
        if n < 3
          if n < 2 return new(-1, falses(0)) # no elements
          else return new((0, trues(0))) end # n = 2: meaning is 1 element of 2
        end
        limi :: Int = (n - 1) ÷ 2 # calculate the required array size
        isprimes :: BitArray = trues(limi)
        @inbounds(
        for i in 1:limi
            p = i + i + 1
            start = (p * p - 1) >>> 1 # shift/divide if LLVM doesn't optimize
            if start > limi
                return new(limi, isprimes)
            end
            if isprimes[i]
                for j in start:p:limi
                  isprimes[j] = false
                end
            end
        end)
    end
end

Base.eltype(::Type{Primes}) = Prime

function Base.length(P::Primes)::Int64
    if P.rangei < 0 return 0 end
    return 1 + count(P.primebits)
end

function Base.iterate(P::Primes, state::Int = 0)::
                                        Union{Tuple{Prime, Int}, Nothing}
    lmt = P.rangei
    if state > lmt return nothing end
    if state <= 0 return (UInt64(2), 1) end
    let
        prmbts = P.primebits
        i = state
        @inbounds(
        while i <= lmt && !prmbts[i] i += 1 end)
        if i > lmt return nothing end
        return (i + i + 1, i + 1)
    end
end
