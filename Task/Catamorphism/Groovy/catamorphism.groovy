def vector1 = [1,2,3,4,5,6,7]
def vector2 = [7,6,5,4,3,2,1]
def map1 = [a:1, b:2, c:3, d:4]

println vector1.inject { acc, val -> acc + val }       // sum
println vector1.inject { acc, val -> acc + val*val }   // sum of squares
println vector1.inject { acc, val -> acc * val }       // product
println vector1.inject { acc, val -> acc<val?val:acc } // max
println ([vector1,vector2].transpose().inject(0) { acc, val -> acc + val[0]*val[1] }) //dot product (with seed 0)

println (map1.inject { Map.Entry accEntry, Map.Entry entry ->     // some sort of weird map-based reduction
    [(accEntry.key + entry.key):accEntry.value + entry.value ].entrySet().toList().pop()
})
