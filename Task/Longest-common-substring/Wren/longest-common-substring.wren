var lcs = Fn.new { |a, b|
    var la = a.count
    var lb = b.count
    var lengths = List.filled(la * lb, 0)
    var greatestLength = 0
    var output = ""
    var i = 0
    for (x in a) {
        var j = 0
        for (y in b) {
            if (x == y) {
                lengths[i*lb + j] = (i == 0 || j == 0) ? 1 : lengths[(i-1)*lb+j-1] + 1
            }
            if (lengths[i*lb+j] > greatestLength) {
                greatestLength = lengths[i*lb+j]
                output = a[i-greatestLength+1..i]
            }
            j = j + 1
        }
        i = i + 1
    }
    return output
}

System.print(lcs.call("thisisatest", "testing123testing"))
