using Primes, Formatting

function moebius(n::Integer)
    @assert n > 0
    m(p, e) = p == 0 ? 0 : e == 1 ? -1 : 0
    return reduce(*, m(p, e) for (p, e) in factor(n) if p  ≥ 0; init=1)
end
μ(n) = moebius(n)

mertens(x) = sum(n -> μ(n), 1:x)
M(x) = mertens(x)

print("First 99 terms of the Mertens function for positive integers:\n   ")
for n in 1:99
    print(lpad(M(n), 3), n % 10 == 9 ? "\n" : "")
end

function maximinM(N)
    z, cros, lastM, maxi, maxM, mini, minM, sumM, pos, neg = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    for i in 1:N
        m = μ(i) + lastM
        if m == 0 && lastM != 0
            cros += 1
        end
        sumM += m
        lastM = m
        if m > maxM
            maxi = i
            maxM = m
        elseif m < minM
            mini = i
            minM = m
        end
        if m > 0
            pos += 1
        elseif m < 0
            neg += 1
        else
            z += 1
        end
    end
    println("\nFor M(x) with x from 1 to $(format(N, commas=true)):")
    println("The maximum of M(x) is M($(format(maxi, commas=true)) = $maxM.")
    println("The minimum of M(x) is M($(format(mini, commas=true))) = $minM.")
    println("The sum of M(x) is $(format(sumM, commas=true)).")
    println("The count of positive M(x) is $(format(pos, commas=true)), count of negative M(x) is $(format(neg, commas=true)).")
    println("M(x) has $(format(z, commas=true)) zeroes in the interval.")
    println("M(x) has $(format(cros, commas=true)) crossings in the interval.")
    diff = pos - neg
    if diff > 0
        println("Positive M(x) exceed negative ones by $(format(diff, commas=true)).")
    else
        println("Negative M(x) exceed positive ones by $(format(-diff, commas=true)).")
    end
end

foreach(maximinM, (1000, 1_000_000, 1_000_000_000))
