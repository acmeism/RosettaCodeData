var s = "1223334444"
var m = {}
for (c in s) {
    var d = m[c]
    m[c] = (d) ? d + 1 : 1
}
var hm = 0
for (k in m.keys) {
    var c = m[k]
    hm = hm + c * c.log2
}
var l = s.count
System.print(l.log2 - hm/l)
