def comb
comb = { m, List list ->
    def n = list.size()
    m == 0 ?
        [[]] :
        (0..(n-m)).inject([]) { newlist, k ->
            def sublist = (k+1 == n) ? [] : list[(k+1)..<n]
            newlist += comb(m-1, sublist).collect { [list[k]] + it }
        }
}

def powerSet = { set ->
    (0..(set.size())).inject([]){ list, i ->  list + comb(i,set as List)}.collect { it as LinkedHashSet } as LinkedHashSet
}
