def stepRange(low, high, step) {
    def range {
        to iterate(f) {
            var i := low
            while (i <= high) {
                f(null, i)
                i += step
            }
        }
    }
    return range
}

for i in stepRange(2, 9, 2) {
  print(`$i, `)
}
println("who do we appreciate?")
