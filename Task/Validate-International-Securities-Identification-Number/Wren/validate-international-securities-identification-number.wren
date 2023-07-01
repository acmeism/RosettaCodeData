import "/str" for Char
import "/iterate" for Stepped
import "/fmt" for Conv, Fmt

var luhn = Fn.new { |s|
    s = s[-1..0]
    var s1 = Stepped.new(s, 2).reduce(0) { |sum, d| sum + d.bytes[0] - 48 }
    var s2 = Stepped.new(s[1..-1], 2).reduce(0) { |sum, d|
        var d2 = (d.bytes[0] - 48) * 2
        return sum  + ((d2 > 9) ?  d2%10 + 1 : d2)
    }
    return (s1 + s2)%10 == 0
}

var isin = Fn.new { |s|
    if (!(s is String && s.count == 12)) return false
    for (i in 0..11) {
        var c = s[i]
        if (i <= 1) {
            if (!Char.isUpper(c)) return false
        } else if (i >= 2 && i <= 10) {
            if (!Char.isUpper(c) && !Char.isDigit(c)) return false
        } else {
            if (!Char.isDigit(c)) return false
        }
    }
    var dec = ""
    for (i in 0...s.count) dec = dec + "%(Conv.atoi(s[i], 36))"
    return luhn.call(dec)
}

var tests = [
    "US0378331005", "US0373831005", "U50378331005", "US03378331005",
    "AU0000XVGZA3", "AU0000VXGZA3", "FR0000988040"
]

for (test in tests) {
    var ans = (isin.call(test)) ? "valid" : "not valid"
    System.print("%(Fmt.s(-13, test)) -> %(ans)")
}
