import "./seq" for Lst
import "./str" for Str

var s = "abracadabra"
var sl = s.toList
var ixs = Lst.indicesOf(sl, "a")[2]
var repl = "ABaCD"
for (i in 0..4) sl[ixs[i]] = repl[i]
s = sl.join()
s = Str.replace(s, "b", "E", 1)
s = Str.replace(s, "r", "F", 2, 1)
System.print(s)
