def countTo = { Long n ->
    long i = 0; while(i < n) { i += 1L }
}

["CPU time":clockCpuTime, "wall clock time":clockRealTime].each { measurementType, timer ->
    println '\n'
    [100000000L, 1000000000L].each { testSize ->
        def measuredTime = timer(countTo.curry(testSize))
        println "Counting to ${testSize} takes ${measuredTime}ms of ${measurementType}"
    }
}
