var bubbleSort = Fn.new { |s, trim|  // allow optional removal of whitespace
    var chars = s.toList
    var n = chars.count
    while (true) {
        var n2 = 0
        for (i in 1...n) {
            if (chars[i - 1].codePoints[0] > chars[i].codePoints[0]) {
                chars.swap(i, i - 1)
                n2 = i
            }
        }
        n = n2
        if (n == 0) break
    }
    s = chars.join()
    return trim ? s.trim() : s
}

var strs = [
    ["forever wren programming language", true],
    ["Now is the time for all good men to come to the aid of their country.", false]
]
for (str in strs) {
    System.print(["Unsorted->" + str[0], "Sorted  ->" + bubbleSort.call(str[0], str[1])].join("\n"))
    System.print()
}
