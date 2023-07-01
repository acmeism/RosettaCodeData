""" From https://en.wikipedia.org/wiki/Domino_tiling#Counting_tilings_of_regions
The number of ways to cover an m X n rectangle with m * n / 2 dominoes, calculated
independently by Temperley & Fisher (1961) and Kasteleyn (1961), is given by
"""
function dominotilingcount(m, n)
    return BigInt(
        floor(
            prod([
                prod([
                    big"4.0" * (cospi(j / (m + 1)))^2 + 4 * (cospi(k / (n + 1)))^2 for
                    k in 1:(n+1)÷2
                ]) for j in 1:(m+1)÷2
            ]),
        ),
    )
end

arrang = dominotilingcount(7, 8)
perms = factorial(big"28")
flips = 2^28

println("Arrangements ignoring values: $arrang")
println("Permutations of 28 dominos: ", perms)
println("Permuted arrangements ignoring flipping dominos: ", arrang * perms)
println("Possible flip configurations: $flips")
println("Possible permuted arrangements with flips: ", flips * arrang * perms)
