// version 1.0.6

fun<T : Comparable<T>> consolidateSets(sets: Array<Set<T>>): Set<Set<T>> {
    val size = sets.size
    val consolidated = BooleanArray(size) // all false by default
    var i = 0
    while (i < size - 1) {
        if (!consolidated[i]) {
            while (true) {
                var intersects = 0
                for (j in (i + 1) until size) {
                    if (consolidated[j]) continue
                    if (sets[i].intersect(sets[j]).isNotEmpty()) {
                        sets[i] = sets[i].union(sets[j])
                        consolidated[j] = true
                        intersects++
                    }
                }
                if (intersects == 0) break
            }
        }
        i++
    }
    return (0 until size).filter { !consolidated[it] }.map { sets[it].toSortedSet() }.toSet()
}

fun main(args: Array<String>) {
    val unconsolidatedSets = arrayOf(
        arrayOf(setOf('A', 'B'), setOf('C', 'D')),
        arrayOf(setOf('A', 'B'), setOf('B', 'D')),
        arrayOf(setOf('A', 'B'), setOf('C', 'D'), setOf('D', 'B')),
        arrayOf(setOf('H', 'I', 'K'), setOf('A', 'B'), setOf('C', 'D'), setOf('D', 'B'), setOf('F', 'G', 'H'))
    )
    for (sets in unconsolidatedSets) println(consolidateSets(sets))
}
