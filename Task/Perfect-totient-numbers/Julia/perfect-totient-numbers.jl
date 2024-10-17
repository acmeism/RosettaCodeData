using Primes

eulerphi(n) = (r = one(n); for (p,k) in factor(abs(n)) r *= p^(k-1)*(p-1) end; r)

const phicache = Dict{Int, Int}()

cachedphi(n) = (if !haskey(phicache, n) phicache[n] = eulerphi(n) end; phicache[n])

function perfecttotientseries(n)
    perfect = Vector{Int}()
    i = 1
    while length(perfect) < n
        tot = i
        tsum = 0
        while tot != 1
            tot = cachedphi(tot)
            tsum += tot
        end
        if tsum == i
            push!(perfect, i)
        end
        i += 1
    end
    perfect
end

println("The first 20 perfect totient numbers are: $(perfecttotientseries(20))")
println("The first 40 perfect totient numbers are: $(perfecttotientseries(40))")
