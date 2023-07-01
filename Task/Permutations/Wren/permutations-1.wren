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

var input = [1, 2, 3]
var perms = permute.call(input)
System.print("There are %(perms.count) permutations of %(input), namely:\n")
perms.each { |perm| System.print(perm) }
