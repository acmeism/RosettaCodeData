val results = mutableListOf<() -> Int>()
for (i in 0..9) {
    results.add { i * i }
}
println(results[3]()) // prints "9"
