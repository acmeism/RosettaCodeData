def binSearchI = { aList, target ->
    def a = aList
    def offset = 0
    while (!a.empty) {
        def n = a.size()
        def m = n.intdiv(2)
        if(a[m] > target) {
            a = a[0..<m]
        } else if (a[m] < target) {
            a = a[(m + 1)..<n]
            offset += m + 1
        } else {
            return [index: offset + m]
        }
    }
    return ["insertion point": offset]
}
