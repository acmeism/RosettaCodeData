using Printf

randN(N) = () -> rand(1:N) == 1 ? 1 : 0
function unbiased(biased::Function)
    this, that = biased(), biased()
    while this == that this, that = biased(), biased() end
    return this
end

@printf "%2s | %10s | %5s | %5s | %8s" "N" "bias./unb." "1s" "0s" "pct ratio"
const nrep = 10000
for N in 3:6
    biased = randN(N)

    v = collect(biased() for __ in 1:nrep)
    v1, v0 = count(v .== 1), count(v .== 0)
    @printf("%2i | %10s | %5i | %5i | %5.2f%%\n", N, "biased", v1, v0, 100 * v1 / nrep)

    v = collect(unbiased(biased) for __ in 1:nrep)
    v1, v0 = count(v .== 1), count(v .== 0)
    @printf("%2i | %10s | %5i | %5i | %5.2f%%\n", N, "unbiased", v1, v0, 100 * v1 / nrep)
end
