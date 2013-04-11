def factorize = { long target ->

    if (target == 1) return [1L]

    if (target < 4) return [1L, target]

    def targetSqrt = Math.sqrt(target)
    def lowfactors = (2L..targetSqrt).grep { (target % it) == 0 }
    if (lowfactors == []) return [1L, target]
    def nhalf = lowfactors.size() - ((lowfactors[-1] == targetSqrt) ? 1 : 0)

    [1] + lowfactors + (0..<nhalf).collect { target.intdiv(lowfactors[it]) }.reverse() + [target]
}
