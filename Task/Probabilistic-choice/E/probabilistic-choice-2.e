/** Makes leaves of the binary tree */
def leaf(value) {
    return def leaf {
        to run(_) { return value }
        to __printOn(out) { out.print("=> ", value) }
    }
}
/** Makes branches of the binary tree */
def split(leastRight, left, right) {
    return def tree {
        to run(specimen) {
            return if (specimen < leastRight) {
                left(specimen)
            } else {
                right(specimen)
            }
        }
        to __printOn(out) {
            out.print("    ")
            out.indent().print(left)
            out.lnPrint("< ")
            out.print(leastRight)
            out.indent().lnPrint(right)
        }
    }
}
def makeIntervalTree(assocs :List[Tuple[any, float64]]) {
    def size :int := assocs.size()
    if (size > 1) {
        def midpoint := size // 2
        return split(assocs[midpoint][1], makeIntervalTree(assocs.run(0, midpoint)),
                                          makeIntervalTree(assocs.run(midpoint)))
    } else {
        def [[value, _]] := assocs
        return leaf(value)
    }
}
def setupProbabilisticChoice(entropy, table :Map[any, float64]) {
    var cumulative := 0.0
    var intervalTable := []
    for value => probability in table {
        intervalTable with= [value, cumulative]
        cumulative += probability
    }
    def total := cumulative
    def selector := makeIntervalTree(intervalTable)
    return def probChoice {
        # Multiplying by the total helps correct for any error in the sum of the inputs
        to run() { return selector(entropy.nextDouble() * total) }
        to __printOn(out) {
            out.print("Probabilistic choice using tree:")
            out.indent().lnPrint(selector)
        }
    }
}
