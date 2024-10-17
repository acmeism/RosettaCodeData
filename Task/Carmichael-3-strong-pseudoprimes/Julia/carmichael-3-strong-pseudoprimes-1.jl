using Primes

function carmichael(pmax::Integer)
    if pmax ≤ 0 throw(DomainError("pmax must be strictly positive")) end
    car = Vector{typeof(pmax)}(0)
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
