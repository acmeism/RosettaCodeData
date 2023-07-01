var expandRange = Fn.new { |s|
    var list = []
    var items = s.split(",")
    for (item in items) {
        var count = item.count { |c| c == "-" }
        if (count == 0 || (count == 1 && item[0] == "-")) {
            list.add(Num.fromString(item))
        } else {
            var items2 = item.split("-")
            var first
            var last
            if (count == 1) {
                first = Num.fromString(items2[0])
                last  = Num.fromString(items2[1])
            } else if (count == 2) {
                first = Num.fromString(items2[1]) * -1
                last  = Num.fromString(items2[2])
            } else {
                first = Num.fromString(items2[1]) * -1
                last  = Num.fromString(items2[3]) * -1
            }
            for (i in first..last) list.add(i)
        }
    }
    return list
}

var s = "-6,-3--1,3-5,7-11,14,15,17-20"
System.print(expandRange.call(s))
