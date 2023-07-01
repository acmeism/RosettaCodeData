var shades = ".:!*oe&#\%@"
var light = [30, 30, -50]

var normalize = Fn.new { |v|
    var len = (v[0]*v[0] + v[1]*v[1] + v[2]*v[2]).sqrt
    for (i in 0..2) v[i] =  v[i] / len
}

var dot = Fn.new { |x, y|
    var d = x[0]*y[0] + x[1]*y[1] + x[2]*y[2]
    return (d < 0) ? -d : 0
}

var drawSphere = Fn.new { |r, k, ambient|
    var vec = [0] * 3
    for (i in (-r).floor..r.ceil) {
        var x = i + 0.5
        for (j in (-2*r).floor..(2*r).ceil) {
            var y = j/2 + 0.5
            if (x*x + y*y <= r*r) {
                var vec = [x, y, (r*r - x*x - y*y).sqrt]
                normalize.call(vec)
                var b = dot.call(light, vec).pow(k) + ambient
                var intensity = ((1 - b) * (shades.count - 1)).truncate
                if (intensity < 0) intensity = 0
                if (intensity >= shades.count - 1) intensity = shades.count - 2
                System.write(shades[intensity])
            } else {
                System.write(" ")
            }
        }
        System.print()
    }
}

normalize.call(light)
drawSphere.call(20, 4, 0.1)
drawSphere.call(10, 2, 0.4)
