// cache factorials from 0 to 11
var fact = List.filled(12, 0)
fact[0] = 1
for (n in 1..11) fact[n] = fact[n-1] * n

for (b in 9..12) {
    System.print("The factorions for base %(b) are:")
    for (i in 1...1500000) {
        var sum = 0
        var j = i
        while (j > 0) {
            var d = j % b
            sum = sum + fact[d]
            j = (j/b).floor
        }
        if (sum == i) System.write("%(i) ")
    }
    System.print("\n")
}
