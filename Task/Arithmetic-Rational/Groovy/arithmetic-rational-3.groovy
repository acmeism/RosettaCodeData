def factorize = { target ->
    if (target == 1L) {
        return [1L]
    } else if ([2L, 3L].contains(target)) {
        return [1L, target]
    }
    def targetSqrt = Math.ceil(Math.sqrt(target)) as long
    def lowfactors = (2L..(targetSqrt)).findAll { (target % it) == 0 }

    if (lowfactors.isEmpty()) {
        return [1L, target]
    }

    def nhalf = lowfactors.size() - ((lowfactors[-1] == targetSqrt) ? 1 : 0)

    return ([1L] + lowfactors + ((nhalf-1)..0).collect { target.intdiv(lowfactors[it]) } + [target]).unique()
}

1.upto(2**19) {
    if ((it % 100000) == 0) { println "HT" }
    else if ((it % 1000) == 0) { print "." }

    def factors = factorize(it)
    def isPerfect = factors.collect{ factor -> new Rational( factor ).reciprocal() }.sum() == new Rational(2)
    if (isPerfect) { println() ; println ([perfect: it, factors: factors]) }
}
