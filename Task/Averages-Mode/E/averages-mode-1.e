pragma.enable("accumulator")
def mode(values) {
    def counts := [].asMap().diverge()
    var maxCount := 0
    for v in values {
        maxCount max= (counts[v] := counts.fetch(v, fn{0}) + 1)
    }
    return accum [].asSet() for v => ==maxCount in counts { _.with(v) }
}
