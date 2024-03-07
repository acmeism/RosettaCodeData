import "./fmt" for Fmt

var mapRange = Fn.new { |a, b, s| b.from + (s - a.from) * (b.to - b.from) / (a.to - a.from) }

var a = 0..10
var b = -1..0
for (s in a) {
    var t = mapRange.call(a, b, s)
    Fmt.print("$2d maps to $ h", s, t)
}
