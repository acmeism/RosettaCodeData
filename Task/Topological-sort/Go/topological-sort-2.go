// General purpose topological sort, not specific to the application of
// library dependencies.  Also adapted from Wikipedia pseudo code.
func topSortDFS(g graph) (order, cyclic []string) {
    L := make([]string, len(g))
    i := len(L)
    temp := map[string]bool{}
    perm := map[string]bool{}
    var cycleFound bool
    var cycleStart string
    var visit func(string)
    visit = func(n string) {
        switch {
        case temp[n]:
            cycleFound = true
            cycleStart = n
            return
        case perm[n]:
            return
        }
        temp[n] = true
        for _, m := range g[n] {
            visit(m)
            if cycleFound {
                if cycleStart > "" {
                    cyclic = append(cyclic, n)
                    if n == cycleStart {
                        cycleStart = ""
                    }
                }
                return
            }
        }
        delete(temp, n)
        perm[n] = true
        i--
        L[i] = n
    }
    for n := range g {
        if perm[n] {
            continue
        }
        visit(n)
        if cycleFound {
            return nil, cyclic
        }
    }
    return L, nil
}
