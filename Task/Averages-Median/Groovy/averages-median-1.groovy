def median(Iterable col) {
    def s = col as SortedSet
    if (s == null) return null
    if (s.empty) return 0
    def n = s.size()
    def m = n.intdiv(2)
    def l = s.collect { it }
    n%2 == 1 ? l[m] : (l[m] + l[m-1])/2
}
