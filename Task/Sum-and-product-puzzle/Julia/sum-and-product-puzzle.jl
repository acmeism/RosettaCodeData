using Primes

function satisfy1(x::Integer)
    prmslt100 = primes(100)
    for i in 2:(x ÷ 2)
        if i ∈ prmslt100 && x - i ∈ prmslt100
            return false
        end
    end
    return true
end

function satisfy2(x::Integer)
    once = false
    for i in 2:isqrt(x)
        if x % i == 0
            j = x ÷ i
            if 2 < j < 100 && satisfy1(i + j)
                if once return false end
                once = true
            end
        end
    end
    return once
end

function satisfyboth(x::Integer)
    if !satisfy1(x) return 0 end
    found = 0
    for i in 2:(x ÷ 2)
        if satisfy2(i * (x - i))
            if found > 0 return 0 end
            found = i
        end
    end
    return found
end

for i in 2:99
    if (j = satisfyboth(i)) > 0
        println("Solution: ($j, $(i - j))")
    end
end
