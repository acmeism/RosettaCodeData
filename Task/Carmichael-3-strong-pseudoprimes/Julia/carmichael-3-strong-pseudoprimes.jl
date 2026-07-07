using Printf
using Primes

function carmichael(pmax::T) where {T <: Integer}
    if pmax ≤ 0 throw(DomainError("pmax must be strictly positive")) end
    car = T[]
    for p in primes(pmax)
        for h₃ in 2:(p-1)
            m = (p - 1) * (h₃ + p)
            pmh = mod(-p ^ 2, h₃)
            for Δ in 1:(h₃+p-1)
                if m % Δ != 0 || Δ % h₃ != pmh continue end
                q = m ÷ Δ + 1
                if !isprime(q) continue end
                r = (p * q - 1) ÷ h₃ + 1
                if !isprime(r) || mod(q * r, p - 1) == 1 continue end
                append!(car, [p, q, r])
            end
        end
    end
    return reshape(car, 3, length(car) ÷ 3)
end

function testcarmichael3(hi = 61)
    car = carmichael(hi)

    curp = tcnt = 0
    print("Carmichael 3 (p×q×r) pseudoprimes, up to p = $hi:")
    for j in sortperm(1:size(car)[2], by=x->(car[1,x], car[2,x], car[3,x]))
        p, q, r = car[:, j]
        c = prod(car[:, j])
        if p != curp
            curp = p
            @printf("\n\np = %d\n  ", p)
            tcnt = 0
        end
        if tcnt == 4
            print("\n  ")
            tcnt = 1
        else
            tcnt += 1
        end
        @printf("p× %d × %d = %d  ", q, r, c)
    end
    println("\n\n", size(car)[2], " results in total.")
end

testcarmichael3()
