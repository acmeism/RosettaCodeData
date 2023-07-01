using Primes

function motzkin(N)
    m = zeros(Int, N)
    m[1] = m[2] = 1
    for i in 3:N
        m[i] = (m[i - 1] * (2i - 1) + m[i - 2] * (3i - 6)) ÷ (i + 1)
    end
    return m
end

println(" n               M[n]     Prime?\n-----------------------------------")
for (i, m) in enumerate(motzkin(42))
    println(lpad(i - 1, 2), lpad(m, 20), lpad(isprime(m), 8))
end
