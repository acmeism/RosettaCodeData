def factorize = { long target ->

    if (target == 1) return [1L]

    if (target < 4) return [1L, target]

    def targetSqrt = Math.sqrt(target)
    def lowfactors = (2L..targetSqrt).findAll { (target % it) == 0 }
    if (lowfactors == []) return [1L, target]
    def nhalf = lowfactors.size() - ((lowfactors[-1]**2 == target) ? 1 : 0)

    [1] + lowfactors + (0..<nhalf).collect { target.intdiv(lowfactors[it]) }.reverse() + [target]
}

def decomposePrimes = { target ->
    def factors = factorize(target) - [1]
    def primeFactors = []
    factors.eachWithIndex { f, i ->
        if (i==0 || factors[0..<i].every {f % it != 0}) {
            primeFactors << f
            def pfPower = f*f
            while (target % pfPower == 0) {
                primeFactors << f
                pfPower *= f
            }
        }
    }
    primeFactors
}
