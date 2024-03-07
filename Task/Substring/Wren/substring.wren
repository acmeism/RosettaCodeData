import "./str" for Str

var s  = "αβγδεζηθ"
var n = 2
var m = 3
var kc = "δ"  // known character
var ks = "δε" // known string
// for reference
System.print("Index of characters:  01234567")
System.print("Complete string:      %(s)")
// starting from n characters in and of m length
System.print("Start %(n), length %(m):    %(Str.sub(s, n...n+m))")
// starting from n characters in, up to the end of the string
System.print("Start %(n), to end:      %(Str.sub(s, n..-1))")
// whole string minus last character
System.print("All but last:         %(Str.sub(s, 0..-2))")
// starting from a known character within the string and of m length
var dx = s.indexOf(kc)
if (dx >= 0) {
    System.print("Start '%(kc)', length %(m):  %(Str.sub(s[dx..-1], 0...m))")
}
// starting from a known substring within the string and of m length
var sx = s.indexOf(ks)
if (sx >= 0) {
    System.print("Start '%(ks)', length %(m): %(Str.sub(s[sx..-1], 0...m))")
}
