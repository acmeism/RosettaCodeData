var extractRange  = Fn.new { |list|
    if (list.isEmpty) return ""
    var sb = ""
    var first = list[0]
    var prev = first

    var append = Fn.new { |index|
        if (first == prev) {
            sb = sb + prev.toString
        } else if (first == prev - 1) {
            sb = sb + first.toString + "," + prev.toString
        } else {
            sb = sb + first.toString + "-" + prev.toString
        }
        if (index < list.count - 1) sb = sb + ","
    }

    for (i in 1...list.count) {
        if (list[i] == prev + 1) {
            prev = prev + 1
        } else {
            append.call(i)
            first = list[i]
            prev = first
        }
    }
    append.call(list.count - 1)
    return sb
}

var list1 = [-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20]
System.print(extractRange.call(list1))
var list2 = [0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
            15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
            25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
            37, 38, 39]
System.print(extractRange.call(list2))
