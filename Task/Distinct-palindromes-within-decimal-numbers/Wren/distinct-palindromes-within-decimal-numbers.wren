import "./seq" for Lst
import "./fmt" for Fmt
import "./sort" for Sort

var substrings = Fn.new { |s|
    var ss = []
    var n = s.count
    for (i in 0...n) {
        for (j in 1..n-i) ss.add(s[i...i + j])
    }
    return ss
}

System.print("Number  Palindromes")
for (i in 100..125) {
    var pals = []
    var ss = substrings.call(i.toString)
    for (s in ss) {
        if (s == s[-1..0]) pals.add(s)
    }
    pals = Lst.distinct(pals)
    var cmp = Fn.new { |i, j| (i.count - j.count).sign }
    Sort.insertion(pals, cmp) // sort by length
    Fmt.print("$d   $3s", i, pals)
}

var nums = [
    "9", "169", "12769", "1238769", "123498769", "12346098769", "1234572098769",
    "123456832098769", "12345679432098769", "1234567905432098769", "123456790165432098769",
    "83071934127905179083", "1320267947849490361205695"
]
System.print("\nNumber                    Has no >= 2 digit palindromes")
for (num in nums) {
    var ss = substrings.call(num).where { |s| s.count > 1 }
    var none = !ss.any { |s| s == s[-1..0] }
    Fmt.print("$-25s $s", num, none)
}
