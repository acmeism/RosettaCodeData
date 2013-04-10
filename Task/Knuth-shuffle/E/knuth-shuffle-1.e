def shuffle(array, random) {
    for bound in (2..(array.size())).descending() {
        def i := random.nextInt(bound)
        def swapTo := bound - 1
        def t := array[swapTo]
        array[swapTo] := array[i]
        array[i] := t
    }
}
