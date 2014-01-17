[createFoos1, createFoos2].each { createFoos ->
    print "Objects distinct for n = "
    (2..<20).each { n ->
        def foos = createFoos(n)
        foos.eachWithIndex { here, i ->
            foos.eachWithIndex { there, j ->
                assert (here == there) == (i == j)
            }
        }
        print "${n} "
    }
    println()
}
