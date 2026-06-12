import "./math" for Math, Int

var MOON = "🌙"

class Lunar {
    static zero { Lunar.of(0) }
    static one  { Lunar.of(1) }
    static nine { Lunar.of(9) }

    construct of(n) {
        if (!((n is Num) && n.isInteger && n >= 0)) {
            Fiber.abort("Argument must be a non-negative integer.")
        }
        _n = n
    }

    n { _n }

    getOps_(other) {
        if (!(other is Lunar)) other = Lunar.of(other)
        var op1 = Int.digits(_n)
        var op2 = Int.digits(other.n)
        var c1 = op1.count
        var c2 = op2.count
        if (c1 < c2) {
            op1 = [0] * (c2 - c1) + op1
        } else  if (c2 < c1) {
            op2 = [0] * (c1 - c2) + op2
        }
        return [op1, op2]
    }

    +(other) {
        var ops = getOps_(other)
        var res = (0...ops[0].count).map { |i| Math.max(ops[0][i], ops[1][i]) }.join("")
        return Lunar.of(Num.fromString(res))
    }

    *(other) {
        var ops = getOps_(other)
        var count = ops[0].count
        var lunars = List.filled(count, null)
        var zeros = ""
        for (i in count-1..0) {
            var num = (0...count).map { |j| Math.min(ops[0][i], ops[1][j]) }.join("")
            if (i < count - 1) zeros = zeros + "0"
            lunars[count-1-i] = Lunar.of(Num.fromString(num + zeros))
        }
        return lunars.reduce { |acc, x| acc + x }
    }

    ==(other) { _n == other.n }

    <(other)  { _n < other.n }

    toString { _n.toString }
}

var tests = [ [976, 348], [23, 321], [232, 35], [123, 32192, 415, 8] ]
for (test in tests) {
    var sum  = test.reduce(Lunar.zero) { |acc, x| acc + x }
    var prod = test.reduce(Lunar.nine) { |acc, x| acc * x }
    System.print("Lunar add: %(test.join(" " + MOON + "+ ")) = %(sum)")
    System.print("Lunar mul: %(test.join(" " + MOON + "× ")) = %(prod)\n")
}

System.print("First 20 distinct even lunar numbers:")
var i = 0
var evens = []
while (evens.count < 20) {
    var even = Lunar.of(i) * 2
    var isDistinct = true
    for (j in evens) {
        if (even == j) {
            isDistinct = false
            break
        }
    }
    if (isDistinct) evens.add(even)
    i = i + 1
}
System.print(evens.join(" "))

System.print("\nFirst 20 square lunar numbers:")
System.print((0...20).map { |i| Lunar.of(i) * i }.join(" "))

System.print("\nFirst 20 factorial lunar numbers:")
var fact = Lunar.one
for (i in 1..20) {
    fact = fact * i
    System.write("%(fact) ")
}
System.write("\n\nFirst number whose lunar square is smaller than the previous: ")
var prev = Lunar.zero
i = 1
while (true) {
    var curr = Lunar.of(i) * i
    if (curr < prev) {
        System.print(i)
        break
    }
    prev = curr
    i = i + 1
}
