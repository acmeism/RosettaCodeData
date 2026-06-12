import "./seq" for Lst

var substrings = Fn.new { |s|
    var n = s.count
    if (n == 0) return [""]
    var ss = []
    for (i in 0...n) {
        for (len in 1..n-i) ss.add(s[i...i+len])
    }
    return ss
}

System.print("The longest substring(s) of the following without repeating characters are:\n")
var strs = ["xyzyabcybdfd", "xyzyab", "zzzzz", "a", ""]
for (s in strs) {
    var longest = []
    var longestLen = 0
    for (ss in substrings.call(s)) {
        if (Lst.distinct(ss.toList).count == ss.count) {
            if (ss.count >= longestLen) {
                if (ss.count > longestLen) {
                    longest.clear()
                    longestLen = ss.count
                }
                longest.add(ss)
            }
        }
    }

    longest = Lst.distinct(longest)
    System.print("String = '%(s)'")
    System.print(longest)
    System.print("Length = %(longest[0].count)\n")
}
