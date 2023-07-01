func isHappyNumber(var n:Int) -> Bool {
    var cycle = [Int]()

    while n != 1 && !cycle.contains(n) {
        cycle.append(n)
        var m = 0
        while n > 0 {
            let d = n % 10
            m += d * d
            n = (n  - d) / 10
        }
        n = m
    }
    return n == 1
}

var found = 0
var count = 0
while found != 8 {
    if isHappyNumber(count) {
        print(count)
        found++
    }
    count++
}
