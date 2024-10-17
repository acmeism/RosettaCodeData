using Primes

function isbrilliant(n)
    p = factor(n).pe
    return (length(p) == 1 && p[1][2] == 2) ||
       length(p) == 2 && ndigits(p[1][1]) == ndigits(p[2][1]) && p[1][2] == p[2][2] == 1
end

function testbrilliants()
    println("First 100 brilliant numbers:")
    foreach(p -> print(lpad(p[2], 5), p[1] % 20 == 0 ? "\n" : ""),
       enumerate(filter(isbrilliant, 1:1370)))
    bcount, results, positions = 0, zeros(Int, 9), zeros(Int, 9)
    for n in 1:10^10
        if isbrilliant(n)
            bcount += 1
            for i in 1:9
                if n >= 10^i && results[i] == 0
                    results[i] = n
                    positions[i] = bcount
                    println("First >=", lpad(10^i, 12), " is", lpad(bcount, 8),
                       " in the series: $n")
                end
            end
        end
    end
    return results, positions
end

testbrilliants()
