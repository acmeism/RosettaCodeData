def beadSort = { list ->
    final nPoles = list.max()
    list.collect {
        print "."
        ([true] * it) + ([false] * (nPoles - it))
    }.transpose().collect { pole ->
        print "."
        pole.findAll { ! it } + pole.findAll { it }
    }.transpose().collect{ beadTally ->
        beadTally.findAll{ it }.size()
    }
}
