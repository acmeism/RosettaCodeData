import "/dynamic" for Tuple

var Circle = Tuple.create("Circle", ["x", "y", "r"])

var solveApollonius = Fn.new { |c1, c2, c3, s1, s2, s3|
    var x1 = c1.x
    var y1 = c1.y
    var r1 = c1.r

    var x2 = c2.x
    var y2 = c2.y
    var r2 = c2.r

    var x3 = c3.x
    var y3 = c3.y
    var r3 = c3.r

    var v11 = 2 * x2 - 2 * x1
    var v12 = 2 * y2 - 2 * y1
    var v13 = x1 * x1 - x2 * x2 + y1 * y1 - y2 * y2 - r1 * r1 + r2 * r2
    var v14 = 2 * s2 * r2 - 2 * s1 * r1

    var v21 = 2 * x3 - 2 * x2
    var v22 = 2 * y3 - 2 * y2
    var v23 = x2 * x2 - x3 * x3 + y2 * y2 - y3 * y3 - r2 * r2 + r3 * r3
    var v24 = 2 * s3 * r3 - 2 * s2 * r2

    var w12 = v12 / v11
    var w13 = v13 / v11
    var w14 = v14 / v11

    var w22 = v22 / v21 - w12
    var w23 = v23 / v21 - w13
    var w24 = v24 / v21 - w14

    var p = -w23 / w22
    var q =  w24 / w22
    var m = -w12 * p - w13
    var n =  w14 - w12 * q

    var a = n * n +  q * q - 1
    var b = 2 * m * n - 2 * n * x1 + 2 * p * q - 2 * q * y1 + 2 * s1 * r1
    var c = x1 * x1 + m * m - 2 * m * x1 + p * p + y1 * y1 - 2 * p * y1 - r1 * r1

    var d = b * b - 4 * a * c
    var rs = (-b - d.sqrt) / (2 * a)
    var xs = m + n * rs
    var ys = p + q * rs
    return Circle.new(xs, ys, rs)
}

var c1 = Circle.new(0, 0, 1)
var c2 = Circle.new(4, 0, 1)
var c3 = Circle.new(2, 4, 2)
System.print("Circle%(solveApollonius.call(c1, c2, c3,  1,  1,  1))")
System.print("Circle%(solveApollonius.call(c1, c2, c3, -1, -1, -1))")
