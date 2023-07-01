func sumSeries(var n: Int) -> Double {
    var ret: Double = 0

    for i in 1...n {
        ret += (1 / pow(Double(i), 2))
    }

    return ret
}

output: 1.64393456668156
