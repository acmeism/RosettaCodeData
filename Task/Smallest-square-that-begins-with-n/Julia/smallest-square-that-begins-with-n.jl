using BenchmarkTools

function smsq(n = 49)
    results = zeros(Int, n)
    found, square, delta = 0, 1, 3
    while found < n
        k = square
        while k > 0
            if k <= n && results[k] == 0
                results[k] = square
                found += 1
            end
            k ÷= 10
        end
        square += delta
        delta += 2
    end
    return results
end

foreach(p -> print(rpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), enumerate(smsq()))
println()
@btime smsq(1_000_000)
