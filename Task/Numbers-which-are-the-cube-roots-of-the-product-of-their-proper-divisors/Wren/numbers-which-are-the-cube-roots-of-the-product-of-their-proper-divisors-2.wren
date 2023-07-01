import "./fmt" for Fmt

var divisorCount = Fn.new { |n|
    var i = 1
    var k = (n%2 == 0) ? 1 : 2
    var count = 0
    while (i <= n.sqrt) {
        if (n%i == 0) {
            count = count + 1
            var j = (n/i).floor
            if (j != i) count = count + 1
        }
        i = i + k
    }
    return count
}

var numbers50 = []
var count = 0
var n = 1
System.print("First 50 numbers which are the cube roots of the products of their proper divisors:")
while (true) {
    var dc = divisorCount.call(n)
    if (n == 1 || dc == 8) {
        count = count + 1
        if (count <= 50) {
            numbers50.add(n)
            if (count == 50) Fmt.tprint("$3d", numbers50, 10)
        } else if (count == 500) {
            Fmt.print("\n500th   : $,d", n)
        } else if (count == 5000) {
            Fmt.print("5,000th : $,d", n)
        } else if (count == 50000) {
            Fmt.print("50,000th: $,d", n)
            break
        }
    }
    n = n + 1
}
