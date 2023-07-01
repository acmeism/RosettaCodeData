def time = { Closure c ->
    def start = System.currentTimeMillis()
    def result = c()
    def elapsedMS = (System.currentTimeMillis() - start)/1000
    printf '(%6.4fs elapsed)', elapsedMS
    result
}

def dashes = '---------------------'
print "   n!       elapsed time   "; (0..15).each { def length = Math.max(it - 3, 3); printf " %${length}d", it }; println()
print "--------- -----------------"; (0..15).each { def length = Math.max(it - 3, 3); print " ${dashes[0..<length]}" }; println()
[recursive:rFact, iterative:iFact].each { name, fact ->
    printf "%9s ", name
    def factList = time { (0..15).collect {fact(it)} }
    factList.each { printf ' %3d', it }
    println()
}
