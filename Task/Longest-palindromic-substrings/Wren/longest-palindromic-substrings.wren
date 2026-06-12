import "./seq" for Lst
import "./fmt" for Fmt

var longestPalSubstring = Fn.new { |s|
    var len = s.count
    if (len <= 1) return [s]
    var targetLen = len
    var longest = []
    var i = 0
    while (true) {
        var j = i + targetLen - 1
        if (j < len) {
            var ss = s[i..j]
            if (ss == ss[-1..0]) longest.add(ss)
            i = i + 1
        } else {
            if (longest.count > 0) return longest
            i = 0
            targetLen = targetLen - 1
        }
    }
}

var strings = ["babaccd", "rotator", "reverse", "forever", "several", "palindrome", "abaracadaraba"]
System.print("The palindromic substrings having the longest length are:")
for (s in strings) {
    var longest = Lst.distinct(longestPalSubstring.call(s))
    Fmt.print("  $-13s Length $d -> $n", s, longest[0].count, longest)
}
