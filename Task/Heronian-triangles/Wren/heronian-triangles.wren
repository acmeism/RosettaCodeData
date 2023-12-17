import "./math" for Int, Nums
import "./sort" for Sort
import "./fmt" for Fmt

var isInteger = Fn.new { |n| n is Num && n.isInteger }

var primHeronian = Fn.new { |a, b, c|
    if (!(isInteger.call(a) && isInteger.call(b) && isInteger.call(c))) return [false, 0, 0]
    if (Int.gcd(Int.gcd(a, b), c) != 1) return [false, 0, 0]
    var p = a + b + c
    var s = p / 2
    var A = (s * (s - a) * (s - b) * (s - c)).sqrt
    if (A > 0 && isInteger.call(A)) return [true, A, p]
    return [false, 0, 0]
}

var ph = []
for (a in 1..200) {
    for (b in a..200) {
        for (c in b..200) {
            var res = primHeronian.call(a, b, c)
            if (res[0]) {
                var sides = [a, b, c]
                ph.add([sides, res[1], res[2], Nums.max(sides)])
            }
        }
    }
}
System.print("There are %(ph.count) primitive Heronian trangles with sides <= 200.")

var cmp = Fn.new { |e1, e2|
    if (e1[1] != e2[1]) return (e1[1] - e2[1]).sign
    if (e1[2] != e2[2]) return (e1[2] - e2[2]).sign
    return (e1[3] - e2[3]).sign
}

Sort.quick(ph, 0, ph.count-1, cmp)
System.print("\nThe first 10 such triangles in sorted order are:")
System.print("   Sides       Area   Perimeter  Max Side")
for (t in ph.take(10)) {
    var sides = Fmt.swrite("$2d x $2d x $2d", t[0][0], t[0][1], t[0][2])
    Fmt.print("$-14s   $2d       $2d       $2d", sides, t[1], t[2], t[3])
}

System.print("\nThe triangles in the previously sorted order with an area of 210 are:")
System.print("   Sides        Area   Perimeter  Max Side")
for (t in ph.where { |e| e[1] == 210 }) {
    var sides = Fmt.swrite("$2d x $3d x $3d", t[0][0], t[0][1], t[0][2])
    Fmt.print("$-14s   $3d       $3d       $3d", sides, t[1], t[2], t[3])
}
