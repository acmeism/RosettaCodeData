println '\nBase:'
[iterative: ccI, recursive: ccR].each { label, cc ->
    print "${label} "
    def start = System.currentTimeMillis()
    def ways = cc(100g, [25g, 10g, 5g, 1g])
    def elapsed = System.currentTimeMillis() - start
    println ("answer: ${ways}   elapsed: ${elapsed}ms")
}

print '\nExtra Credit:\niterative '
def start = System.currentTimeMillis()
def ways = ccI(1000g * 100, [100g, 50g, 25g, 10g, 5g, 1g])
def elapsed = System.currentTimeMillis() - start
println ("answer: ${ways}   elapsed: ${elapsed}ms")
