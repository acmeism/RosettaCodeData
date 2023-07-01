import "/fmt" for Fmt

var cubLine = Fn.new { |n, dx, dy, cde|
    Fmt.write("$*s", n + 1, cde[0])
    for (d in 9*dx - 1...0) System.write(cde[1])
    System.write(cde[0])
    Fmt.print("$*s", dy + 1, cde[2..-1])
}

var cuboid = Fn.new { |dx, dy, dz|
    Fmt.print("cuboid $d $d $d:", dx, dy, dz)
    cubLine.call(dy+1, dx, 0, "+-")
    for (i in 1..dy) cubLine.call(dy-i+1, dx, i-1, "/ |")
    cubLine.call(0, dx, dy, "+-|")
    for (i in 4*dz - dy - 2...0) cubLine.call(0, dx, dy, "| |")
    cubLine.call(0, dx, dy, "| +")
    for (i in 1..dy) cubLine.call(0, dx, dy-i, "| /")
    cubLine.call(0, dx, 0, "+-\n")
}

cuboid.call(2, 3, 4)
cuboid.call(1, 1, 1)
cuboid.call(6, 2, 1)
