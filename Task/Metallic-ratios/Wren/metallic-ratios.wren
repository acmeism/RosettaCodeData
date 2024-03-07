import "./big" for BigInt, BigRat
import "./fmt" for Fmt

var names = ["Platinum", "Golden", "Silver", "Bronze", "Copper","Nickel", "Aluminium", "Iron", "Tin", "Lead"]

var lucas = Fn.new { |b|
    Fmt.print("Lucas sequence for $s ratio, where b = $d:", names[b], b)
    System.write("First 15 elements: ")
    var x0 = 1
    var x1 = 1
    Fmt.write("$d, $d", x0, x1)
    for (i in 1..13) {
        var x2 = b*x1 + x0
        Fmt.write(", $d", x2)
        x0 = x1
        x1 = x2
    }
    System.print()
}

var metallic = Fn.new { |b, dp|
    var x0 = BigInt.one
    var x1 = BigInt.one
    var x2 = BigInt.zero
    var bb = BigInt.new(b)
    var ratio = BigRat.new(BigInt.one, BigInt.one)
    var iters = 0
    var prev = ratio.toDecimal(dp)
    while (true) {
        iters = iters + 1
        x2 = bb*x1 + x0
        ratio = BigRat.new(x2, x1)
        var curr = ratio.toDecimal(dp)
        if (prev == curr) {
            var plural = (iters == 1) ? " " : "s"
            Fmt.print("Value to $d dp after $2d iteration$s: $s\n", dp, iters, plural, curr)
            return
        }
        prev = curr
        x0 = x1
        x1 = x2
    }
}

for (b in 0..9) {
    lucas.call(b)
    metallic.call(b, 32)
}
System.print("Golden ratio, where b = 1:")
metallic.call(1, 256)
