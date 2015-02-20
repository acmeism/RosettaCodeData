Number.metaClass.mixin RationalCategory

def factorize = { target ->
    assert target > 0
    if (target == 1L) { return [1L] }
    if ([2L, 3L].contains(target)) { return [1L, target] }
    def targetSqrt = Math.sqrt(target)
    def lowFactors = (2L..targetSqrt).findAll { (target % it) == 0 }

    if (!lowFactors) { return [1L, target] }
    def highFactors = lowFactors[-1..0].findResults { target.intdiv(it) } - lowFactors[-1]

    return [1L] + lowFactors + highFactors + [target]
}

def perfect = {
    def factors = factorize(it)
    2 as Rational == factors.sum{ factor -> new Rational(1, factor) } \
        ? [perfect: it, factors: factors]
        : null
}

def trackProgress = { if ((it % (100*1000)) == 0) { println it } else if ((it % 1000) == 0) { print "." } }

(1..(2**19)).findResults { trackProgress(it); perfect(it) }.each { println(); print it }
