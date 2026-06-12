using Primes

# Generate factorials (1, 1, 2, 6, 24, ...)
const factorials = accumulate((x, y) -> x * y, big"1":big"100")

function kempner(n::Int)::Int
    n < 2 && return 1
    # Get prime factors and their counts as a dictionary
    factorization = Dict(factor(n))
    for (p, e) in factorization
        v = p ^ e
        p * p >= v && continue
        # Find first factorial divisible by v
        for (i, f) in enumerate(factorials)
            if f % v == 0
                factorization[p] = i ÷ p
                break
            end
        end
    end
    # Return max product of prime and count found in above loop
    return maximum(prod, factorization)
end

# Print first fifty Kempner numbers
println("First fifty Kempner numbers:")
const fifty = [kempner(i) for i in 1:50]
for i in 0:10:49
    for x in fifty[i+1:i+10]
        print(lpad(x, 4))
    end
    println()
end
println()
# Print Kempner numbers for range 77135679311 to 77135679321
for n in 77135679311:77135679321
    println("S($n) = $(kempner(n))")
end
