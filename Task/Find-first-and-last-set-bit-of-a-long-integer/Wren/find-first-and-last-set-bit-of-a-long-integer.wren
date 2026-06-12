import "./big" for BigInt
import "./fmt" for Fmt

var rupb = Fn.new { |x| (x is BigInt) ? x.bitLength - 1 : x.log2.floor }
var rlwb = Fn.new { |x| rupb.call(x & ~(x - 1)) }

System.print("Powers of 42 below 2^32 using Num:")
var x = 1
for (i in 0..5) {
    Fmt.print("42^$d = $,11d  rupb: $2d  rlwb: $2d", i, x, rupb.call(x), rlwb.call(x))
    x = x * 42
}

System.print("\nPowers of 1302 below 2^64 using BigInt:")
x = BigInt.new(1)
for (i in 0..6) {
    Fmt.print("1302^$d = $,25s  rupb: $2s  rlwb: $2s", i, x, rupb.call(x), rlwb.call(x))
    x = x * 1302
}
