import "./dynamic" for Struct
import "./fmt" for Fmt

var fields = [
    "name",
    "x",  // position (mk)
    "v",  // velocity (km/s)
    "m"   // mass (kg)
]

var Planet = Struct.create("Planet", fields)

var planets = [
    Planet.new("Mercury", 6.9817930e7, 38.86, 3.301e23),
    Planet.new("Venus",   1.0893900e8, 35.02, 4.867e24),
    Planet.new("Earth",   1.4710000e8, 29.29, 5.972e24),
    Planet.new("Mars",    2.4923000e8, 24.07, 6.417e23),
    Planet.new("Jupiter", 8.1662000e8, 13.06, 1.898e27),
    Planet.new("Saturn",  1.5065300e9, 9.69,  5.683e26),
    Planet.new("Uranus",  3.0013900e9, 6.8,   8.681e25),
    Planet.new("Neptune", 4.5589000e9, 5.43,  1.024e26)
]

// Zero fills the significand of a numeric string expressed
// in scientific notation to 'p' decimal places.
var ezfill = Fn.new { |e, p|
    var s = e.split("e")
    var n = Num.fromString(s[0])
    return Fmt.f(0, n, p) + "e" + s[1]
}

System.print("=== NKTg Law Verification (31/12/2024) ===\n")
System.print("Planet    NKTg1          Interpolated m    NASA m         Delta m")
System.print("-" * 70)

for (p in planets) {
    var momentum = p.m * p.v
    var nktg1 = p.x * momentum
    var mi = nktg1 / (p.x * p.v)
    var nm = p.m
    var dm = nm - mi
    nktg1 = ezfill.call(Fmt.e(0, nktg1, 6), 6)
    mi    = ezfill.call(Fmt.e(0, mi, 6), 6)
    nm    = ezfill.call(Fmt.e(0, nm, 6), 6)
    dm    = ezfill.call(Fmt.e(0, dm, 6), 6)
    Fmt.print("$-7s   $12s   $12s      $12s   $11s", p.name, nktg1, mi, nm, dm)
}
