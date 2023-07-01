var gss = Fn.new { |s|
    var best = 0
    var start = 0
    var end = 0
    var sum = 0
    var sumStart = 0
    var i = 0
    for (x in s) {
        sum = sum + x
        if (sum > best) {
            best = sum
            start = sumStart
            end = i + 1
        } else if (sum < 0) {
            sum = 0
            sumStart = i + 1
        }
        i = i + 1
    }
    return [s[start...end], best]
}

var tests = [
    [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1],
    [-1, 1, 2, -5, -6],
    [],
    [-1, -2, -1]
]
for (test in tests) {
    System.print("Input:   %(test)")
    var res = gss.call(test)
    var subSeq = res[0]
    var sum = res[1]
    System.print("Sub seq: %(subSeq)")
    System.print("Sum:     %(sum)\n")
}
