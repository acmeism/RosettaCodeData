var duration = Fn.new { |s|
    if (s < 1) return "0 sec"
    var dur = ""
    var divs = [7, 24, 60, 60, 1]
    var units = ["wk", "d", "hr", "min", "sec"]
    var t = divs.reduce { |prod, div| prod * div }
    for (i in 0...divs.count) {
        var u = (s/t).floor
        if (u > 0) {
            dur = dur + "%(u) %(units[i]), "
            s = s % t
        }
        t = t / divs[i]
    }
    if (dur.endsWith(", ")) dur = dur[0..-3]
    return dur
}

for (s in [7259, 86400, 6000000]) System.print(duration.call(s))
