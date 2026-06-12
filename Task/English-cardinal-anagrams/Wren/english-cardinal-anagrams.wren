import "./sort" for Sort
import "./fmt" for Fmt, Name

for (limit in [1000, 10000]) {
    var ana = {}
    for (i in 0..limit) {
        var key = Sort.quick(Name.fromNum(i).toList).join("")
        if (ana.containsKey(key)) {
            ana[key].add(i)
        } else {
            ana[key] = [i]
        }
    }
    if (limit == 1000) {
        var all = []
        for (v in ana.values) {
            if (v.count > 1) all.addAll(v)
        }
        System.print("First 30 English cardinal anagrams:")
        Fmt.tprint("$3d", all.sort().take(30), 10)
        System.print()
    }
    var count = ana.count { |me| me.value.count > 1 }
    Fmt.print("Count of English cardinal anagrams up to $,d: $,d", limit, count)
    var max = 0
    var largest
    for (v in ana.values) {
        if (v.count > max) {
            max = v.count
            largest = [v]
        } else if (v.count == max) {
            largest.add(v)
        }
    }
    Fmt.print("\nLargest group(s) of English cardinal anagrams up to $,d:", limit)
    largest.sort { |l1, l2| l1[0] < l2[0] }
    System.print(largest.map { |l| "[" + l.join(" ") + "]" }.join("\n"))
    if (limit == 1000) System.print()
}
