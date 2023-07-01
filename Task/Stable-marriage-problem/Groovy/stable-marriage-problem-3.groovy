enum Man {
    abe, bob, col, dan, ed, fred, gav, hal, ian, jon
}

enum Woman {
    abi, bea, cath, dee, eve, fay, gay, hope, ivy, jan
}

Map<Man,Map<Woman,Integer>> mansWomanRanking = [
    (abe): [(abi):10, (eve):9, (cath):8, (ivy):7, (jan):6, (dee):5, (fay):4, (bea):3, (hope):2, (gay):1],
    (bob): [(cath):10, (hope):9, (abi):8, (dee):7, (eve):6, (fay):5, (bea):4, (jan):3, (ivy):2, (gay):1],
    (col): [(hope):10, (eve):9, (abi):8, (dee):7, (bea):6, (fay):5, (ivy):4, (gay):3, (cath):2, (jan):1],
    (dan): [(ivy):10, (fay):9, (dee):8, (gay):7, (hope):6, (eve):5, (jan):4, (bea):3, (cath):2, (abi):1],
    (ed):  [(jan):10, (dee):9, (bea):8, (cath):7, (fay):6, (eve):5, (abi):4, (ivy):3, (hope):2, (gay):1],
    (fred):[(bea):10, (abi):9, (dee):8, (gay):7, (eve):6, (ivy):5, (cath):4, (jan):3, (hope):2, (fay):1],
    (gav): [(gay):10, (eve):9, (ivy):8, (bea):7, (cath):6, (abi):5, (dee):4, (hope):3, (jan):2, (fay):1],
    (hal): [(abi):10, (eve):9, (hope):8, (fay):7, (ivy):6, (cath):5, (jan):4, (bea):3, (gay):2, (dee):1],
    (ian): [(hope):10, (cath):9, (dee):8, (gay):7, (bea):6, (abi):5, (fay):4, (ivy):3, (jan):2, (eve):1],
    (jon): [(abi):10, (fay):9, (jan):8, (gay):7, (eve):6, (bea):5, (dee):4, (cath):3, (ivy):2, (hope):1],
]

Map<Woman,List<Man>> womansManRanking = [
    (abi): [(bob):10, (fred):9, (jon):8, (gav):7, (ian):6, (abe):5, (dan):4, (ed):3, (col):2, (hal):1],
    (bea): [(bob):10, (abe):9, (col):8, (fred):7, (gav):6, (dan):5, (ian):4, (ed):3, (jon):2, (hal):1],
    (cath):[(fred):10, (bob):9, (ed):8, (gav):7, (hal):6, (col):5, (ian):4, (abe):3, (dan):2, (jon):1],
    (dee): [(fred):10, (jon):9, (col):8, (abe):7, (ian):6, (hal):5, (gav):4, (dan):3, (bob):2, (ed):1],
    (eve): [(jon):10, (hal):9, (fred):8, (dan):7, (abe):6, (gav):5, (col):4, (ed):3, (ian):2, (bob):1],
    (fay): [(bob):10, (abe):9, (ed):8, (ian):7, (jon):6, (dan):5, (fred):4, (gav):3, (col):2, (hal):1],
    (gay): [(jon):10, (gav):9, (hal):8, (fred):7, (bob):6, (abe):5, (col):4, (ed):3, (dan):2, (ian):1],
    (hope):[(gav):10, (jon):9, (bob):8, (abe):7, (ian):6, (dan):5, (hal):4, (ed):3, (col):2, (fred):1],
    (ivy): [(ian):10, (col):9, (hal):8, (gav):7, (fred):6, (bob):5, (abe):4, (ed):3, (jon):2, (dan):1],
    (jan): [(ed):10, (hal):9, (gav):8, (abe):7, (bob):6, (jon):5, (col):4, (ian):3, (fred):2, (dan):1],
]

// STABLE test
Map<Woman,Man> matches = match(mansWomanRanking, womansManRanking)
matches.each { w, m ->
    println "${w} (his '${mansWomanRanking[m][w]}' girl) is engaged to ${m} (her '${womansManRanking[w][m]}' guy)"
}
assert matches.keySet() == Woman.values() as Set
assert matches.values() as Set == Man.values() as Set
println ''

assert isStable(matches, mansWomanRanking, womansManRanking)

// PERTURBED test
println 'Swapping partners now ...'
def temp = matches[abi]
matches[abi] = matches[bea]
matches[bea] = temp
matches.each { w, m ->
    println "${w} (his '${mansWomanRanking[m][w]}' girl) is engaged to ${m} (her '${womansManRanking[w][m]}' guy)"
}
println ''

assert ! isStable(matches, mansWomanRanking, womansManRanking)
