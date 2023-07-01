func shellsort<T where T : Comparable>(inout seq: [T]) {
    var inc = seq.count / 2
    while inc > 0 {
        for (var i, el) in EnumerateSequence(seq) {
            while i >= inc && seq[i - inc] > el {
                seq[i] = seq[i - inc]
                i -= inc
            }
            seq[i] = el
        }
        if inc == 2 {
            inc = 1
        } else {
            inc = inc * 5 / 11
        }
    }
}
