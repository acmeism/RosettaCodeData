def topWordCounts = { String content, int n ->
    def mapCounts = [:]
    content.toLowerCase().split(/\W+/).each {
        mapCounts[it] = (mapCounts[it] ?: 0) + 1
    }
    def top = (mapCounts.sort { a, b -> b.value <=> a.value }.collect{ it })[0..<n]
    println "Rank Word Frequency\n==== ==== ========="
    (0..<n).each { printf ("%4d %-4s %9d\n", it+1, top[it].key, top[it].value) }
}
