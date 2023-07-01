import "/fmt" for Fmt
import "/iterate" for Stepped

var luhn = Fn.new { |s|
    // reverse digits
    s = s[-1..0]
    // sum the odd digits
    var s1 = Stepped.new(s, 2).reduce(0) { |sum, d| sum + d.bytes[0] - 48 }
    // sum two times the even digits
    var s2 = Stepped.new(s[1..-1], 2).reduce(0) { |sum, d|
        var d2 = (d.bytes[0] - 48) * 2
        return sum  + ((d2 > 9) ?  d2%10 + 1 : d2)
    }
    // check if s1 + s2 ends in zero
    return (s1 + s2)%10 == 0
}

var tests = [ "49927398716", "49927398717", "1234567812345678", "1234567812345670"]
for (test in tests) {
    var ans = (luhn.call(test)) ? "pass" : "fail"
    System.print("%(Fmt.s(-16, test)) -> %(ans)")
}
