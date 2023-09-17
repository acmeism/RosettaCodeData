var finalRes = []

var amb // recursive closure
amb = Fn.new { |wordsets, res|
    if (wordsets.count == 0) {
        finalRes.addAll(res)
        return true
    }
    var s = ""
    var l = res.count
    if (l > 0) s = res[l-1]
    res.add("")
    for (word in wordsets[0]) {
        res[l] = word
        if (l > 0 && s[-1] != res[l][0]) continue
        if (amb.call(wordsets[1..-1], res.toList)) return true
    }
    return false
}

var wordsets = [
    [ "the", "that", "a" ],
    [ "frog", "elephant", "thing" ],
    [ "walked", "treaded", "grows" ],
    [ "slowly", "quickly" ]
]

if (amb.call(wordsets, [])) {
    System.print(finalRes.join(" "))
} else {
    System.print("No amb found")
}
