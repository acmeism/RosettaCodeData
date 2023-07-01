var pernicious = Fn.new { |w|
    var ff    = 2.pow(32) - 1
    var mask1 = (ff / 3).floor
    var mask3 = (ff / 5).floor
    var maskf = (ff / 17).floor
    var maskp = (ff / 255).floor
    w = w - (w >> 1 & mask1)
    w = (w & mask3) + (w >>2 & mask3)
    w = (w + (w >> 4)) & maskf
    return 0xa08a28ac >> (w*maskp >> 24) & 1 != 0
}

var i = 0
var n = 1
while (i < 25) {
    if (pernicious.call(n)) {
        System.write("%(n) ")
        i = i + 1
    }
    n = n + 1
}
System.print()
for (n in 888888877..888888888) {
    if (pernicious.call(n)) System.write("%(n) ")
}
System.print()
