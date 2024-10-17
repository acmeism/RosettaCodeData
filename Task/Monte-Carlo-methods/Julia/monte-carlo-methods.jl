using Printf

function monteπ(n)
    s = count(rand() ^ 2 + rand() ^ 2 < 1 for _ in 1:n)
    return 4s / n
end

for n in 10 .^ (3:8)
    p = monteπ(n)
    println("$(lpad(n, 9)): π ≈ $(lpad(p, 10)), pct.err = ", @sprintf("%2.5f%%", 100 * abs(p - π) / π))
end
