bags(n,cache="") = n < 1 ? [(0, "")] :
    [(c + 1, "(" * s * ")") for (c, s) in bagchain((0, ""), n - 1,
        n < 2 ? [] : reduce(append!, [bags(x) for x in n-1:-1:1]))]

bagchain(x, n, bb, start=1) = n < 1 ? [x] :
    reduce(append!, [bagchain((x[1] + bb[i][1], x[2] * bb[i][2]),
        n - bb[i][1], bb, i) for i in start:length(bb) if bb[i][1] <= n])

for bag in bags(5)
    println(bag[2])
end
