import "./math" for Math
import "./fmt" for Fmt

// constants
var RE  = 6371000  // radius of earth in meters
var DD  = 0.001    // integrate in this fraction of the distance already covered
var FIN = 1e7      // integrate only to a height of 10000km, effectively infinity

// The density of air as a function of height above sea level.
var rho = Fn.new { |a| (-a/8500).exp }

// a = altitude of observer
// z = zenith angle (in degrees)
// d = distance along line of sight
var height = Fn.new { |a, z, d|
    var aa = RE + a
    var hh = (aa * aa + d * d - 2 * d * aa * (Math.radians(180-z).cos)).sqrt
    return hh - RE
}

// Integrates density along the line of sight.
var columnDensity = Fn.new { |a, z|
    var sum = 0
    var d = 0
    while (d < FIN) {
        var delta = DD.max(DD * d) // adaptive step size to avoid it taking forever
        sum = sum + rho.call(height.call(a, z, d + 0.5 * delta)) * delta
        d = d + delta
    }
    return sum
}

var airmass = Fn.new { |a, z| columnDensity.call(a, z) / columnDensity.call(a, 0) }

System.print("Angle     0 m              13700 m")
System.print("------------------------------------")
var z = 0
while (z <= 90) {
    Fmt.print("$2d      $11.8f      $11.8f", z, airmass.call(0, z), airmass.call(13700, z))
    z = z + 5
}
