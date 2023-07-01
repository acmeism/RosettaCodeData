var s = "abracadabra"
var t = "abra"
var u = "ra"
var v = "cad"
System.print("'%(s)' starts with '%(t)' is %(s.startsWith(t))")
var indices = []
var start = 0
while (true) {
    var ix = s.indexOf(u, start)
    if (ix >= 0) {
        indices.add(ix)
        start = ix + u.count
        if (start >= s.count) break
    } else break
}
var contained = indices.count > 0
System.print("'%(s)' contains '%(u)' is %(contained) %(contained ? "at indices %(indices)" : "")")
System.print("'%(s)' ends with '%(v)' is %(s.endsWith(v))")
