def sum(lo, hi, f) {
    var temp := 0
    for i in lo..hi { temp += f(i) }
    return temp
}
sum(1, 100, fn i { 1/i })
