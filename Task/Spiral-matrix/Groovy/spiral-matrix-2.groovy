(1..10).each { n ->
    spiralMatrix(n).each { row ->
        row.each { printf "%5d", it }
        println()
    }
    println ()
}
