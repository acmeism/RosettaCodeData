using Formatting
using Primes

pcf(n) = n * (n - 1) ÷ 2 + 1 - sum(totient, 1:n)

foreach(p -> print(rpad(p[2], 5), p[1] % 20 == 0 ? "\n" : ""), pairs(map(pcf, 1:100)))

for expo in 1:6
    println("The ", format(10^expo, commas = true), "th pair with common factors count is ",
       format(pcf(10^expo), commas = true))
end
