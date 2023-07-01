import "/fmt" for Fmt, Conv
import "/str" for Str

var toOctets = Fn.new { |n|
    var s = Conv.itoa(n, 2)
    var le = s.count
    var r = le % 7
    var d = (le/7).floor
    if (r > 0) {
        d = d + 1
        s = Fmt.zfill(7 * d, s)
    }
    var chunks = Str.chunks(s, 7)
    var last = "0" + chunks[-1]
    s = chunks[0..-2].map { |ch| "1" + ch }.join() + last
    return Str.chunks(s, 8).map { |ch| Conv.atoi(ch, 2) }.toList
}

var fromOctets = Fn.new { |octets|
    var s = ""
    for (oct in octets) {
        var bin = Conv.itoa(oct, 2)
        bin = Fmt.zfill(7, bin)
        s = s + bin[-7..-1]
    }
    return Conv.atoi(s, 2)
}

var tests = [2097152, 2097151]
for (test in tests) {
    var octets = toOctets.call(test)
    var display = octets.map { |oct| "Ox" + Fmt.xz(2, oct) }.toList
    System.write("%(test) -> %(Fmt.v("s", 4, display, 0, " ", "")) -> ")
    System.print(fromOctets.call(octets))
}
