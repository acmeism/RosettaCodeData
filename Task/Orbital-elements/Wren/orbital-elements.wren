import "./vector" for Vector3

var orbitalStateVectors = Fn.new { |semimajorAxis, eccentricity, inclination,
                                    longitudeOfAscendingNode, argumentOfPeriapsis, trueAnomaly|
    var i = Vector3.new(1, 0, 0)
    var j = Vector3.new(0, 1, 0)
    var k = Vector3.new(0, 0, 1)

    var mulAdd = Fn.new { |v1, x1, v2, x2| v1 * x1 + v2 * x2 }

    var rotate = Fn.new { |i, j, alpha|
        return [mulAdd.call(i,  alpha.cos, j, alpha.sin),
                mulAdd.call(i, -alpha.sin, j, alpha.cos)]
    }

    var p = rotate.call(i, j, longitudeOfAscendingNode)
    i = p[0]
    j = p[1]
    p = rotate.call(j, k, inclination)
    j = p[0]
    p = rotate.call(i, j, argumentOfPeriapsis)
    i = p[0]
    j = p[1]

    var l = semimajorAxis * ((eccentricity == 1) ? 2 : (1 - eccentricity * eccentricity))
    var c = trueAnomaly.cos
    var s = trueAnomaly.sin
    var r = l / (1 + eccentricity * c)
    var rprime = s * r * r / l
    var position = mulAdd.call(i, c, j, s) * r
    var speed = mulAdd.call(i, rprime * c - r * s, j, rprime * s + r * c)
    speed = speed / speed.length
    speed = speed * (2 / r - 1 / semimajorAxis).sqrt
    return [position, speed]
}

var ps = orbitalStateVectors.call(1, 0.1, 0, 355 / (113 * 6), 0, 0)
System.print("Position : %(ps[0])")
System.print("Speed    : %(ps[1])")
