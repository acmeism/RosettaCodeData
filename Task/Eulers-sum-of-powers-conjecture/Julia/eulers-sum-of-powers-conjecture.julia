const lim = 250
const pwr = 5
const p = [i^pwr for i in 1:lim]

x = zeros(Int, pwr-1)
y = 0

for a in combinations(1:lim, pwr-1)
    b = searchsorted(p, sum(p[a]))
    0 < length(b) || continue
    x = a
    y = b[1]
    break
end

if y == 0
    println("No solution found for power = ", pwr, " and limit = ", lim, ".")
else
    s = [@sprintf("%d^%d", i, pwr) for i in x]
    s = join(s, " + ")
    println("A solution is ", s, " = ", @sprintf("%d^%d", y, pwr), ".")
end
