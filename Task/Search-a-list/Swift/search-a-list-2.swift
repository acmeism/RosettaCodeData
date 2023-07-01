let haystack = ["Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"]
for needle in ["Washington","Bush"] {
    if let index = find(haystack, needle) {
        println("\(index) \(needle)")
    } else {
        println("\(needle) is not in haystack")
    }
}
