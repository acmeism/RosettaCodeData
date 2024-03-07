import "./fmt" for Fmt

var d = 30
var r = d * Num.pi / 180
var s = 0.5
var c = 3.sqrt / 2
var t = 1 / 3.sqrt

Fmt.print("sin($9.6f deg) = $f",  d, (d*Num.pi/180).sin)
Fmt.print("sin($9.6f rad) = $f",  r, r.sin)
Fmt.print("cos($9.6f deg) = $f",  d, (d*Num.pi/180).cos)
Fmt.print("cos($9.6f rad) = $f",  r, r.cos)
Fmt.print("tan($9.6f deg) = $f",  d, (d*Num.pi/180).tan)
Fmt.print("tan($9.6f rad) = $f",  r, r.tan)
Fmt.print("asin($f) = $9.6f deg", s, s.asin*180/Num.pi)
Fmt.print("asin($f) = $9.6f rad", s, s.asin)
Fmt.print("acos($f) = $9.6f deg", c, c.acos*180/Num.pi)
Fmt.print("acos($f) = $9.6f rad", c, c.acos)
Fmt.print("atan($f) = $9.6f deg", t, t.atan*180/Num.pi)
Fmt.print("atan($f) = $9.6f rad", t, t.atan)
