import "./seq" for Lst
import "./math" for Nums

var limit = 1e6

var selfRefSeq = Fn.new { |s|
    var sb = ""
    for (d in "9876543210") {
        if (s.contains(d)) {
            var count = s.count { |c| c == d }
            sb = sb + "%(count)%(d)"
        }
    }
    return sb
}

var permute // recursive
permute = Fn.new { |input|
    if (input.count == 1) return [input]
    var perms = []
    var toInsert = input[0]
    for (perm in permute.call(input[1..-1])) {
        for (i in 0..perm.count) {
            var newPerm = perm.toList
            newPerm.insert(i, toInsert)
            perms.add(newPerm)
        }
    }
    return perms
}

var sieve = List.filled(limit, 0)
var elements = []
for (n in 1...limit) {
    if (sieve[n] == 0) {
        elements.clear()
        var next = n.toString
        elements.add(next)
        while (true) {
            next = selfRefSeq.call(next)
            if (elements.contains(next)) {
                var size = elements.count
                sieve[n] = size
                if (n > 9) {
                    var perms = permute.call(n.toString.toList).map { |p| p.join("") }.toList
                    perms = Lst.distinct(perms)
                    for (perm in perms) {
                        if (perm[0] != "0") {
                            var k = Num.fromString(perm.join(""))
                            sieve[k] = size
                        }
                    }
                }
                break
            }
            elements.add(next)
        }
    }
}
var maxIterations = Nums.max(sieve)
for (n in 1...limit) {
    if (sieve[n] >= maxIterations) {
        System.print("%(n) -> Iterations = %(maxIterations)")
        var next = n.toString
        for (i in 1..maxIterations) {
            System.print(next)
            next = selfRefSeq.call(next)
        }
        System.print()
    }
}
