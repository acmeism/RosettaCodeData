import "./math" for Int, Nums
import "./fmt" for Fmt

var primes = Int.primeSieve(1e5)
var foundCombo = false

var findCombo // recursive
findCombo = Fn.new { |k, x, m, n, combo|
    if (k >= m) {
        if (Nums.sum(combo.map { |i| primes[i] }.toList) == x) {
            var s = (m > 1) ? "s" : ""
            Fmt.write("Partitioned $5d with $2d prime$s: ", x, m, s)
            for (i in 0...m) {
                System.write(primes[combo[i]])
                System.write((i < m - 1) ? "+" : "\n")
            }
            foundCombo = true
        }
    } else {
        for (j in 0...n) {
            if (k == 0 || j > combo[k - 1]) {
                combo[k] = j
                if (!foundCombo) findCombo.call(k + 1, x, m, n, combo)
            }
        }
    }
}

var partition = Fn.new { |x, m|
    if (x < 2 || m < 1 || m >= x) Fiber.abort("Invalid argument(s)")
    var n = primes.where { |p| p <= x }.count
    if (n < m) Fiber.abort("Not enough primes")
    var combo = List.filled(m, 0)
    foundCombo = false
    findCombo.call(0, x, m, n, combo)
    if (!foundCombo) {
        var s = (m > 1) ? "s" : ""
        Fmt.print("Partitioned $5d with $2d prime$s: (not possible)", x, m, s)
    }
}

var a = [
    [99809, 1],
    [18, 2],
    [19, 3],
    [20, 4],
    [2017, 24],
    [22699, 1],
    [22699, 2],
    [22699, 3],
    [22699, 4],
    [40355, 3]
]
for (p in a) partition.call(p[0], p[1])
