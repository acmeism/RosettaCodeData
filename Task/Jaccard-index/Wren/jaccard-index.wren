import "./set" for Set
import "./iterate" for Indexed
import "./fmt" for Fmt

var jaccardIndex = Fn.new { |a, b|
    if (a.count == 0 && b.count == 0) return 1
    return a.intersect(b).count / a.union(b).count
}

var a = Set.new([])
var b = Set.new([1, 2, 3, 4, 5])
var c = Set.new([1, 3, 5, 7, 9])
var d = Set.new([2, 4, 6, 8, 10])
var e = Set.new([2, 3, 5, 7])
var f = Set.new([8])
var isets = Indexed.new([a, b, c, d, e, f])
for (se in isets) {
    var i = String.fromByte(se.index + 65)
    var v = se.value
    v = v.toList.sort() // force original sorted order
    Fmt.print("$s = $n", i, v)
}
System.print()
for (se1 in isets) {
    var i1 = String.fromByte(se1.index + 65)
    var v1 = se1.value
    for (se2 in isets) {
        var i2 = String.fromByte(se2.index + 65)
        var v2 = se2.value
        Fmt.print("J($s, $s) = $h", i1, i2, jaccardIndex.call(v1, v2))
    }
}
