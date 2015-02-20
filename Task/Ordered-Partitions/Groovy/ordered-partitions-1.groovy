def partitions = { int... sizes ->
    int n = (sizes as List).sum()
    def perms = n == 0 ? [[]] : (1..n).permutations()
    Set parts = perms.collect { p -> sizes.collect { s -> (0..<s).collect { p.pop() } as Set } }
    parts.sort{ a, b ->
        if (!a) return 0
    def comp = [a,b].transpose().find { aa, bb -> aa != bb }
    if (!comp) return 0
    def recomp = comp.collect{ it as List }.transpose().find { aa, bb -> aa != bb }
        if (!recomp) return 0
        return recomp[0] <=> recomp[1]
    }
}
