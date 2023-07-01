var gcd = Fn.new { |x, y|
    while (y != 0) {
        var t = y
        y = x % y
        x = t
    }
    return x.abs
}

var lcm = Fn.new { |x, y|
    if (x == 0 && y == 0) return 0
    return (x*y).abs / gcd.call(x, y)
}

var xys = [[12, 18], [-6, 14], [35, 0]]
for (xy in xys) {
    System.print("lcm(%(xy[0]), %(xy[1]))\t%("\b"*5) = %(lcm.call(xy[0], xy[1]))")
}
