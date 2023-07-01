import "/fmt" for Fmt

var toGray = Fn.new { |n| n ^ (n>>1) }

var fromGray = Fn.new { |g|
    var b = 0
    while (g != 0) {
        b = b ^ g
        g = g >> 1
    }
    return b
}

System.print("decimal  binary  gray    decoded")
for (b in 0..31) {
    System.write("  %(Fmt.d(2, b))     %(Fmt.bz(5, b))")
    var g = toGray.call(b)
    System.write("   %(Fmt.bz(5, g))")
    System.print("   %(Fmt.bz(5, fromGray.call(g)))")
}
