var lookAndSay = Fn.new { |s|
    var res = ""
    var digit = s[0]
    var count = 1
    for (i in 1...s.count) {
        if (s[i] == digit) {
            count = count + 1
        } else {
            res = res + "%(count)%(digit)"
            digit = s[i]
            count = 1
        }
    }
    return res + "%(count)%(digit)"
}

var las = "1"
for (i in 1..15) {
    System.print(las)
    las = lookAndSay.call(las)
}
