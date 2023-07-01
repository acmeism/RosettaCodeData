import "/fmt" for Conv, Fmt

var predicates = [
    Fn.new { |s| s.count == 13 },  // indexing starts at 0 but first bit ignored
    Fn.new { |s| (7..12).count { |i| s[i] == "1" } == 3 },
    Fn.new { |s| [2, 4, 6, 8, 10, 12].count { |i| s[i] == "1" } == 2 },
    Fn.new { |s| s[5] == "0" || (s[6] == "1" && s[7] == "1") },
    Fn.new { |s| s[2] == "0" && s[3]  == "0" && s[4] == "0" },
    Fn.new { |s| [1, 3, 5, 7, 9, 11].count { |i| s[i] == "1" } == 4 },
    Fn.new { |s| Conv.itob(Conv.btoi(s[2] == "1") ^ Conv.btoi(s[3] == "1")) },
    Fn.new { |s| s[7] == "0" || (s[5] == "1" && s[6] == "1") },
    Fn.new { |s| (1..6).count { |i| s[i] == "1" } == 3 },
    Fn.new { |s| s[11] == "1" && s[12] == "1" },
    Fn.new { |s| (7..9).count { |i| s[i] == "1" } == 1 },
    Fn.new { |s| (1..11).count { |i| s[i] == "1" } == 4 }
]

var show = Fn.new { |s, indent|
    if (indent) System.write("    ")
    for (i in 0...s.count) if (s[i] == "1") System.write("%(i) ")
    System.print()
}

System.print("Exact hits:")
for (i in 0..4095) {
    var s = Fmt.swrite("$013b", i)
    var j = 1
    if (predicates.all { |pred|
       var res = pred.call(s) == (s[j] == "1")
       j = j + 1
       return res
    }) show.call(s, true)
}

System.print("\nNear misses:")
for (i in 0..4095) {
    var s = Fmt.swrite("$013b", i)
    var j = 1
    var c = predicates.count { |pred|
        var res = pred.call(s) == (s[j] == "1")
        j = j + 1
        return res
    }
    if (c == 11) {
        var k = 1
        for (pred in predicates) {
            if (pred.call(s) != (s[k] == "1") ) break
            k = k + 1
        }
        Fmt.write("    (Fails at statement $2d)  ", k)
        show.call(s, false)
    }
}
