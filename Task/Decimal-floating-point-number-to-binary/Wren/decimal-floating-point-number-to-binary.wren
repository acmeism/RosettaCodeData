import "./fmt" for Conv, Fmt

var decToBin = Fn.new { |d|
    var whole = d.truncate
    var binary = Conv.itoa(whole, 2) + "."
    var dd = d.fraction
    while (dd > 0) {
        var r = dd * 2
        if (r >= 1) {
            binary = binary + "1"
            dd = r - 1
        } else {
            binary = binary + "0"
            dd = r
        }
    }
    return binary
}

var binToDec = Fn.new { |s|
    var ss = s.replace(".", "")
    var num = Conv.atoi(ss, 2)
    ss = s.split(".")[1]
    ss = ss.replace("1", "0")
    var den = Conv.atoi("1" + ss, 2)
    return num/den
}

var f = 23.34375
Fmt.print("$g\t => $s", f, decToBin.call(f))
var s = "1011.11101"
Fmt.print("$s\t => $g", s, binToDec.call(s))
