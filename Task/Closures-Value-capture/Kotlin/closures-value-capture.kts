val results = mutableListOf<() -> Int>()
var i = 0
while (i < 10) {
    // Closures capture by reference, so reassignment is needed.
    val j = i
    results.add { j * j }
    i++
}
println(results[3]()) // prints "9"
