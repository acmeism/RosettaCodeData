var longestIncreasingSubsequence = Fn.new { |x|
    var n = x.count
    if (n == 0) return []
    if (n == 1) return x
    var p = List.filled(n, 0)
    var m = List.filled(n+1, 0)
    var len = 0
    for (i in 0...n) {
        var lo = 1
        var hi = len
        while (lo <= hi) {
            var mid = ((lo + hi)/2).ceil
            if (x[m[mid]] < x[i]) {
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        var newLen = lo
        p[i] = m[newLen - 1]
        m[newLen] = i
        if (newLen > len) len = newLen
    }
    var s = List.filled(len, 0)
    var k = m[len]
    for (i in len-1..0) {
        s[i] = x[k]
        k = p[k]
    }
    return s
}

var lists = [
    [3, 2, 6, 4, 5, 1],
    [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
]
lists.each { |l| System.print(longestIncreasingSubsequence.call(l)) }
