import "./fmt" for Fmt

var d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
]

var inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9]

var p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
]

var verhoeff = Fn.new { |s, validate, table|
    if (table) {
        System.print("%(validate ? "Validation" : "Check digit") calculations for '%(s)':\n")
        System.print(" i  nᵢ  p[i,nᵢ]  c")
        System.print("------------------")
    }
    if (!validate) s = s + "0"
    var c = 0
    var le = s.count - 1
    for (i in le..0) {
        var ni = s[i].bytes[0] - 48
        var pi = p[(le-i) % 8][ni]
        c = d[c][pi]
        if (table) Fmt.print("$2d  $d      $d     $d", le-i, ni, pi, c)
    }
    if (table && !validate) System.print("\ninv[%(c)] = %(inv[c])")
    return !validate ? inv[c] : c == 0
}

var sts = [["236", true], ["12345", true], ["123456789012", false]]
for (st in sts) {
    var c = verhoeff.call(st[0], false, st[1])
    System.print("\nThe check digit for '%(st[0])' is '%(c)'\n")
    for (stc in [st[0] + c.toString, st[0] + "9"]) {
        var v = verhoeff.call(stc, true, st[1])
        System.print("\nThe validation for '%(stc)' is %(v ? "correct" : "incorrect").\n")
    }
}
