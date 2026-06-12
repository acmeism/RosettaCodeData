var norm = Fn.new { |v| (v[0]*v[0] + v[1]*v[1] + v[2]*v[2]).sqrt }

var normalize = Fn.new { |v|
    var length = norm.call(v)
    return [v[0]/length, v[1]/length, v[2]/length]
}

var dotProduct = Fn.new { |v1, v2| v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2] }

var crossProduct = Fn.new { |v1, v2|
    return [v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0]]
}

var getAngle = Fn.new { |v1, v2| (dotProduct.call(v1, v2) / (norm.call(v1) * norm.call(v2))).acos }

var matrixMultiply = Fn.new { |matrix, v|
    return [dotProduct.call(matrix[0], v), dotProduct.call(matrix[1], v), dotProduct.call(matrix[2], v)]
}

var aRotate = Fn.new { |p, v, a|
    var ca = a.cos
    var sa = a.sin
    var t = 1 - ca
    var x = v[0]
    var y = v[1]
    var z = v[2]
    var r = [
        [ca + x*x*t, x*y*t - z*sa, x*z*t + y*sa],
        [x*y*t + z*sa, ca + y*y*t, y*z*t - x*sa],
        [z*x*t - y*sa, z*y*t + x*sa, ca + z*z*t]
    ]
    return matrixMultiply.call(r, p)
}

var v1 = [5, -6,  4]
var v2 = [8,  5,-30]
var a = getAngle.call(v1, v2)
var cp = crossProduct.call(v1, v2)
var ncp = normalize.call(cp)
var np = aRotate.call(v1, ncp, a)
System.print(np)
