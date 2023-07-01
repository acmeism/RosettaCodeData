var setRightBits = Fn.new { |bits, e, n|
    if (e == 0 || n <= 0) return bits
    var bits2 = bits.toList
    for (i in 0...e - 1) {
        var c = bits[i]
        if (c == 1) {
            var j = i + 1
            while (j <= i + n && j < e) {
                bits2[j] = 1
                j = j + 1
            }
        }
    }
    return bits2
}

var b = "010000000000100000000010000000010000000100000010000010000100010010"
var tests = [["1000", 2], ["0100", 2], ["0010", 2], ["0000", 2], [b, 0], [b, 1], [b, 2], [b, 3]]
for (test in tests) {
    var bits = test[0]
    var e = bits.count
    var n = test[1]
    System.print("n = %(n); Width e = %(e):")
    System.print("    Input b: %(bits)")
    bits = bits.map { |c| c.bytes[0] - 48 }.toList
    bits = setRightBits.call(bits, e, n)
    System.print("     Result: %(bits.join())\n")
}
