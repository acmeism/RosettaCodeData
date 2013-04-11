def gnomeSort(array) {
    var size := array.size()
    var i := 1
    var j := 2
    while (i < size) {
        if (array[i-1] <= array[i]) {
            i := j
            j += 1
        } else {
            def t := array[i-1]
            array[i-1] := array[i]
            array[i] := t
            i -= 1
            if (i <=> 0) {
                i := j
                j += 1
            }
        }
    }
}
