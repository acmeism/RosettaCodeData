var a = 3
while (true) {
    var b = a + 1
    while (true) {
        var c = 1000 - a - b
        if (c <= b) break
        if (a*a + b*b == c*c) {
            System.print("a = %(a), b = %(b), c = %(c)")
            System.print("a + b + c = %(a + b + c)")
            System.print("a * b * c = %(a * b * c)")
            return
        }
        b = b + 1
    }
    a = a + 1
}
