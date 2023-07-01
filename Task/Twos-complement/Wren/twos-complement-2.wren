var pow32 = 2.pow(32)
var pow31 = 2.pow(31)
var bs = [-pow31, -pow31+1, -2, -1, 0, 1, 2, pow31-2, pow31-1]
for (b in bs) {
    var b2 = ~b + 1
    if (b2 > pow31) b2 = b2 - pow32
    System.print("%(b) -> %(b2)")
}
