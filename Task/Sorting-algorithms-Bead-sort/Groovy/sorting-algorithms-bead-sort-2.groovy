def beadSortVerbose = { list ->
    final nPoles = list.max()
    // each row is a number tally-arrayed across the abacus
    def beadTallies = list.collect { number ->
        print "."
        // true == bead, false == no bead
        ([true] * number) + ([false] * (nPoles - number))
    }
    // each row is an abacus pole
    def abacusPoles = beadTallies.transpose()
    def abacusPolesDrop = abacusPoles.collect { pole ->
        print "."
        // beads drop to the BOTTOM of the pole
        pole.findAll { ! it } + pole.findAll { it }
    }
    // each row is a number again
    def beadTalliesDrop = abacusPolesDrop.transpose()
    beadTalliesDrop.collect{ beadTally -> beadTally.findAll{ it }.size() }
}
