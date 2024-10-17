using Formatting, Primes

function isblum(n)
    pe = factor(n).pe
    return length(pe) == 2 && all(p -> p[2] == 1 && p[1] % 4 == 3, pe)
end

const blum400k = @view (filter(isblum, 1:9_000_000))[1:400_000]

println("First 50 Blum integers:")
foreach(p -> print(rpad(p[2], 4), p[1] % 10 == 0 ? "\n" : ""), enumerate(blum400k[1:50]))

for idx in [26_828, 100_000, 200_000, 300_000, 400_000]
    println("\nThe $(format(idx, commas = true))th Blum number is ",
       format(blum400k[idx], commas = true), ".")
end

println("\n% distribution of the first 400,000 Blum integers is:")
for d in [1, 3, 7, 9]
    println(lpad(round(count(x -> x % 10 == d, blum400k) / 4000, digits=3), 8), "% end in $d")
end
