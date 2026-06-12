var findCircle = Fn.new { |x1, y1, x2, y2, x3, y3|
    var x12 = x1 - x2
    var x13 = x1 - x3
    var y12 = y1 - y2
    var y13 = y1 - y3
    var y31 = y3 - y1
    var y21 = y2 - y1
    var x31 = x3 - x1
    var x21 = x2 - x1

    var sx13 = x1 * x1 - x3 * x3
    var sy13 = y1 * y1 - y3 * y3
    var sx21 = x2 * x2 - x1 * x1
    var sy21 = y2 * y2 - y1 * y1

    var f = sx13 * x12 + sy13 * x12 + sx21 * x13 + sy21 * x13
    f = f / (y31 * x12 - y21 * x13) / 2

    var g = sx13 * y12 + sy13 * y12 + sx21 * y13 + sy21 * y13
    g = g / (x31 * y12 - x21 * y13) / 2

    var c = -x1 * x1 - y1 * y1 - 2 * g * x1 - 2 * f * y1
    var h = -g
    var k = -f
    var r = (h * h + k * k - c).sqrt
    return [h, k, r]
}

var hkr = findCircle.call(22.83, 2.07, 14.39, 30.24, 33.65, 17.31)
System.print("Centre is at %([hkr[0], hkr[1]])")
System.print("Radius is %(hkr[2])")

System.print("\nCheck radius as the distance between the centre and the first point:")
System.print(((22.83 - hkr[0]).pow(2) + (2.07 - hkr[1]).pow(2)).sqrt)
