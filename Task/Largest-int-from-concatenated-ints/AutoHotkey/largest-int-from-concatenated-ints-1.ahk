LargestConcatenatedInts(var){
	StringReplace, var, A_LoopField,%A_Space%,, all
	Sort, var, D`, fConcSort
	StringReplace, var, var, `,,, all
	return var
}

ConcSort(a, b){
	m := a . b	, n := b . a
    return m < n ? 1 : m > n ? -1 : 0
}
