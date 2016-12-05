func doSqnc(m:Int) {
    var aList = [Int](count: m + 1, repeatedValue: 0)
    var k1 = 2
    var lg2 = 1
    var amax:Double = 0
    aList[0] = 1
    aList[1] = 1

    var v = aList[2]

    for n in 2...m {
        let add = aList[v] + aList[n - v]
        aList[n] = add
        v = aList[n]

        if amax < Double(v) * 1.0 / Double(n) {
            amax = Double(v) * 1.0 / Double(n)
        }

        if (k1 & n == 0) {
            println("Maximum between 2^\(lg2) and 2^\(lg2 + 1) was \(amax)")
            amax = 0
            lg2++
        }
        k1 = n
    }
}

doSqnc(1 << 20)
