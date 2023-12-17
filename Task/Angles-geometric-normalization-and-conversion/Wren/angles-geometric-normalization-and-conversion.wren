import "./fmt" for Fmt

var d2d = Fn.new { |d| d % 360 }
var g2g = Fn.new { |g| g % 400 }
var m2m = Fn.new { |m| m % 6400 }
var r2r = Fn.new { |r| r % (2*Num.pi) }
var d2g = Fn.new { |d| d2d.call(d) * 400 / 360 }
var d2m = Fn.new { |d| d2d.call(d) * 6400 / 360 }
var d2r = Fn.new { |d| d2d.call(d) * Num.pi / 180 }
var g2d = Fn.new { |g| g2g.call(g) * 360 / 400 }
var g2m = Fn.new { |g| g2g.call(g) * 6400 / 400 }
var g2r = Fn.new { |g| g2g.call(g) * Num.pi / 200 }
var m2d = Fn.new { |m| m2m.call(m) * 360 / 6400 }
var m2g = Fn.new { |m| m2m.call(m) * 400 / 6400 }
var m2r = Fn.new { |m| m2m.call(m) * Num.pi / 3200 }
var r2d = Fn.new { |r| r2r.call(r) * 180 / Num.pi }
var r2g = Fn.new { |r| r2r.call(r) * 200 / Num.pi }
var r2m = Fn.new { |r| r2r.call(r) * 3200 / Num.pi }

var f1 = "$15m $15m $15m $15m $15m"
var f2 = "$15.7g $15.7g $15.7g $15.7g $15.7g"
var angles = [-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000]
Fmt.print(f1, "degrees", "normalized degs", "gradians", "mils", "radians")
for (a in angles) {
    Fmt.print(f2, a, d2d.call(a), d2g.call(a), d2m.call(a), d2r.call(a))
}
f1 = "\n" + f1
Fmt.print(f1, "gradians", "normalized grds", "degrees", "mils", "radians")
for (a in angles) {
    Fmt.print(f2, a, g2g.call(a), g2d.call(a), g2m.call(a), g2r.call(a))
}
Fmt.print(f1, "mils", "normalized mils", "degrees", "gradians", "radians")
for (a in angles) {
    Fmt.print(f2, a, m2m.call(a), m2d.call(a), m2g.call(a), m2r.call(a))
}
Fmt.print(f1, "radians", "normalized rads", "degrees", "gradians", "mils")
for (a in angles) {
    Fmt.print(f2, a, r2r.call(a), r2d.call(a), r2g.call(a), r2m.call(a))
}
