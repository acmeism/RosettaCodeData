using Printf

function getlgc(r::Integer, a::Integer, c::Integer, m::Integer, sh::Integer)
    state = r
    return function lgcrand()
        state = mod(a * state + c, m)
        return state >> sh
    end
end

seed, nrep = 0, 10
bsdrand = getlgc(seed, 1103515245, 12345, 2 ^ 31, 0)

println("The first $nrep results for a BSD rand seeded with $seed:")
for _ in 1:nrep
    @printf("%14d\n", bsdrand())
end

msrand = getlgc(seed, 214013, 2531011, 2 ^ 31, 16)

println("\nThe first $nrep results for a M\$ rand seeded with $seed:")
for _ in 1:nrep
    @printf("%14d\n", msrand())
end
