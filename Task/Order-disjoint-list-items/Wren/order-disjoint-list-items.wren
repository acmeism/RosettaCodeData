import "./fmt" for Fmt

var NULL = "\0"

var orderDisjointList = Fn.new { |m, n|
    var nList = n.split(" ")
    // first replace the first occurrence of items of 'n' in 'm' with the NULL character
    // which we can safely assume won't occur in 'm' naturally
    for (item in nList) {
        var ix = m.indexOf(item)
        if (ix >= 0) {
            var le = item.count
            m = m[0...ix] + NULL + m[ix + le..-1]
        }
    }
    // now successively replace the NULLs with items from nList
    var mList = m.split(NULL)
    var sb = ""
    for (i in 0...nList.count) sb = sb + mList[i] + nList[i]
    return sb + mList[-1]
}

var ma = [
    "the cat sat on the mat",
    "the cat sat on the mat",
    "A B C A B C A B C",
    "A B C A B D A B E",
    "A B",
    "A B",
    "A B B A"
]

var na = [
    "mat cat",
    "cat mat",
    "C A C A",
    "E A D A",
    "B",
    "B A",
    "B A"
]

for (i in 0...ma.count) {
    Fmt.print("$-22s  -> $-7s  -> $s", ma[i], na[i], orderDisjointList.call(ma[i], na[i]))
}
