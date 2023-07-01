import "/set" for Set

var consolidateSets = Fn.new { |sets|
    var size = sets.count
    var consolidated = List.filled(size, false)
    var i = 0
    while (i < size - 1) {
        if (!consolidated[i]) {
            while (true) {
                var intersects = 0
                for (j in i+1...size) {
                    if (!consolidated[j]) {
                        if (!sets[i].intersect(sets[j]).isEmpty) {
                            sets[i].addAll(sets[j])
                            consolidated[j] = true
                            intersects = intersects + 1
                        }
                    }
                }
                if (intersects == 0) break
            }
        }
        i = i + 1
    }
    return (0...size).where { |i| !consolidated[i] }.map { |i| sets[i] }.toList
}

var unconsolidatedSets = [
    [Set.new(["A", "B"]), Set.new(["C", "D"])],
    [Set.new(["A", "B"]), Set.new(["B", "D"])],
    [Set.new(["A", "B"]), Set.new(["C", "D"]), Set.new(["D", "B"])],
    [Set.new(["H", "I", "K"]), Set.new(["A", "B"]), Set.new(["C", "D"]),
     Set.new(["D", "B"]), Set.new(["F", "G", "H"])]
]
for (sets in unconsolidatedSets) {
    System.print("Unconsolidated: %(sets)")
    System.print("Cosolidated   : %(consolidateSets.call(sets))\n")
}
