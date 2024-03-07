import "./fmt" for Fmt
import "./big" for BigInt

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

var derange = Fn.new { |input|
    if (input.isEmpty) return [input]
    var perms = permute.call(input)
    var derangements = []
    for (perm in perms) {
        var deranged = true
        for (i in 0...perm.count) {
            if (perm[i] == i) {
                deranged = false
                break
            }
        }
        if (deranged) derangements.add(perm)
    }
    return derangements
}

var subFactorial // recursive
subFactorial = Fn.new { |n|
    if (n == 0) return BigInt.one
    if (n == 1) return BigInt.zero
    return (subFactorial.call(n-1) + subFactorial.call(n-2)) * (n - 1)
}

var input = [0, 1, 2, 3]
var derangements = derange.call(input)
System.print("There are %(derangements.count) derangements of %(input), namely:\n")
System.print(derangements.join("\n"))

System.print("\nN  Counted   Calculated")
System.print("-  -------   ----------")
for (n in 0..9) {
    var list = List.filled(n, 0)
    for (i in 0...n) list[i] = i
    var counted = derange.call(list).count
    Fmt.print("$d  $-9d $-9i", n, counted, subFactorial.call(n))
}
System.print("\n!20 = %(subFactorial.call(20))")
