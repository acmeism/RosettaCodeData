import "./seq" for Lst

var permute // recursive
permute = Fn.new { |input|
    if (input.count == 1) return [input]
    var perms = []
    var toInsert = input[0]
    for (perm in permute.call(input.skip(1).toList)) {
        for (i in 0..perm.count) {
            var newPerm = perm.toList
            newPerm.insert(i, toInsert)
            perms.add(newPerm)
        }
    }
    return perms
}

/* looks for for all possible solutions, not just the first */
var dinesman = Fn.new { |occupants, predicates|
    return permute.call(occupants).where { |perm| predicates.all { |pred| pred.call(perm) } }
}

var occupants = ["Baker", "Cooper", "Fletcher", "Miller", "Smith"]
var predicates = [
    Fn.new { |p| p[-1] != "Baker" },
    Fn.new { |p| p[0]  != "Cooper" },
    Fn.new { |p| p[-1] != "Fletcher" && p[0] != "Fletcher" },
    Fn.new { |p| Lst.indexOf(p, "Miller") > Lst.indexOf(p, "Cooper") },
    Fn.new { |p| (Lst.indexOf(p, "Smith") - Lst.indexOf(p, "Fletcher")).abs > 1 },
    Fn.new { |p| (Lst.indexOf(p, "Fletcher") - Lst.indexOf(p, "Cooper")).abs > 1 }
]

var solutions = dinesman.call(occupants, predicates)
var size = solutions.count
if (size == 0) {
    System.print("No solutions found")
} else {
    var plural = (size == 1) ? "" : "s"
    System.print("%(size) solution%(plural) found, namely:\n")
    for (solution in solutions) {
        var i = 0
        for (name in solution) {
            System.print("Floor %(i+1) -> %(name)")
            i = i + 1
        }
        System.print()
    }
}
