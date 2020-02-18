using Printf

p = [1/i for i in 5:11]
plen = length(p)
q = [0.0, [sum(p[1:i]) for i = 1:plen]]
plab = [char(i) for i in 0x05d0:(0x05d0+plen)]
hi = 10^6
push!(p, 1.0 - sum(p))
plen += 1

accum = zeros(Int, plen)

for i in 1:hi
    accum[sum(rand() .>= q)] += 1
end

r = accum/hi

println("Rates at which items are selected (", hi, " trials).")
println(" Item  Expected   Actual")
for i in 1:plen
    println(@sprintf("   \u2067%s   %8.6f  %8.6f", plab[i], p[i], r[i]))
end

println()
println("Rates at which items are selected (", hi, " trials).")
println(" Item         Count   Expected   Actual")
for i in 1:plen
    println(@sprintf("   %s yields  %6d   %8.6f  %8.6f",
                     plab[i], accum[i], p[i], r[i]))
end
