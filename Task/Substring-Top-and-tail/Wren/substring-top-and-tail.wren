import "./str" for Str

var a = "Beyoncé"
var b = Str.delete(a, 0)
var len = a.codePoints.count
var c = Str.delete(a, len-1)
var d = Str.delete(c, 0)
for (e in [a, b, c, d]) System.print(e)
