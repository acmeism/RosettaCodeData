var split = Fn.new { |s|
    if (s.count == 0) return ""
    var res = []
    var last = s[0]
    var curr = last
    for (c in s.skip(1)) {
        if (c == last) {
            curr = curr + c
        } else {
            res.add(curr)
            curr = c
        }
        last = c
    }
    res.add(curr)
    return res.join(", ")
}

var s = "gHHH5YY++///\\"
System.print(split.call(s))
