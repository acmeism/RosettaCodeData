for (a in 3..332) {
    var b = a + 1
    while (true) {
        var c = 1000 - a - b
        if (c <= b) break
        if (a*a + b*b == c*c) {
            System.print("a = %(a), b = %(b), c = %(c)")
            System.print("a + b + c = %(a + b + c)")
            System.print("a * b * c = %(a * b * c)")
        }
        b = b + 1
    }
}
