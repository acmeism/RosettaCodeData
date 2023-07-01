def time = { Closure c ->
    def start = System.currentTimeMillis()
    def result = c()
    def elapsedMS = (System.currentTimeMillis() - start)/1000
    printf '(%6.4fs elapsed)', elapsedMS
    result
}

print "  F(n)      elapsed time   "; (-10..10).each { printf ' %3d', it }; println()
print "--------- -----------------"; (-10..10).each { print ' ---' }; println()
[recursive:rFib, iterative:iFib, analytic:aFib].each { name, fib ->
    printf "%9s ", name
    def fibList = time { (-10..10).collect {fib(it)} }
    fibList.each { printf ' %3d', it }
    println()
}
