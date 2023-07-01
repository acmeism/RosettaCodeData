var inCarpet = Fn.new { |x, y|
    while (true) {
        if (x == 0 || y == 0) return true
        if (x%3 == 1 && y%3 == 1) return false
        x = (x/3).floor
        y = (y/3).floor
    }
}

var carpet = Fn.new { |n|
    var power = 3.pow(n)
    for (i in 0...power) {
        for (j in 0...power) {
            System.write(inCarpet.call(i, j) ? "#" : " ")
        }
        System.print()
    }
}

carpet.call(3)
