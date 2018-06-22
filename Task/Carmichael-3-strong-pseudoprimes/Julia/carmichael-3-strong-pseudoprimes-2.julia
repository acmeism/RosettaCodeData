hi = 61
car = carmichael(hi)

curp = tcnt = 0
print("Carmichael 3 (p×q×r) pseudoprimes, up to p = $hi:")
for j in sortperm(1:size(car)[2], by=x->(car[1,x], car[2,x], car[3,x]))
    p, q, r = car[:, j]
    c = prod(car[:, j])
    if p != curp
        curp = p
        @printf("\n\np = %d\n  ", p)
        tcnt = 0
    end
    if tcnt == 4
        print("\n  ")
        tcnt = 1
    else
        tcnt += 1
    end
    @printf("p× %d × %d = %d  ", q, r, c)
end
println("\n\n", size(car)[2], " results in total.")
