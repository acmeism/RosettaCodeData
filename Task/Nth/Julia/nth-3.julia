println("Tests of ordinal formatting of integers.")
for (i, n) in enumerate(0:25)
    (i - 1) % 10 == 0 && println()
    @printf("%7s", ordinal(n))
end

println()
for (i, n) in enumerate(250:265)
    (i - 1) % 10 == 0 && println()
    @printf("%7s", ordinal(n))
end

println()
for (i, n) in enumerate(1000:1025)
    (i - 1) % 10 == 0 && println()
    @printf("%7s", ordinal(n))
end
