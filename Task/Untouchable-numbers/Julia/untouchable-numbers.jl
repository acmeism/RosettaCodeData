using Primes

function properfactorsum(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    pop!(f)
    return sum(f)
end

const maxtarget, sievelimit = 1_000_000, 512_000_000
const untouchables = ones(Bool, maxtarget)

for i in 2:sievelimit
    n = properfactorsum(i)
    if n <= maxtarget
        untouchables[n] = false
    end
end
for i in 6:maxtarget
    if untouchables[i] && (isprime(i - 1) || isprime(i - 3))
        untouchables[i] = false
    end
end

println("The untouchable numbers ≤ 2000 are: ")
for (i, n) in enumerate(filter(x -> untouchables[x], 1:2000))
    print(rpad(n, 5), i % 10 == 0 || i == 196 ? "\n" : "")
end
for N in [2000, 10, 100, 1000, 10_000, 100_000, 1_000_000]
    println("The count of untouchable numbers ≤ $N is: ", count(x -> untouchables[x], 1:N))
end
