using Printf, Distributions, IterTools

newv(n::Int, p::Float64) = rand(Bernoulli(p), n)
runs(v::Vector{Int}) = sum((a & ~b) for (a, b) in zip(v, IterTools.chain(v[2:end], v[1])))

mrd(n::Int, p::Float64) = runs(newv(n, p)) / n

nrep = 500

for p in 0.1:0.2:1
    lim = p * (1 - p)

    println()
    for ex in 10:2:14
        n = 2 ^ ex
        sim = mean(mrd.(n, p) for _ in 1:nrep)
        @printf("nrep = %3i\tp = %4.2f\tn = %5i\np · (1 - p) = %5.3f\tsim = %5.3f\tΔ = %3.1f%%\n",
                nrep, p, n, lim, sim, lim > 0 ? abs(sim - lim) / lim * 100 : sim * 100)
    end
end
