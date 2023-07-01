import "/big" for BigInt

var Const  = BigInt.fromBaseString("2545F4914F6CDD1D", 16)
var Mask64 = (BigInt.one << 64) - BigInt.one
var Mask32 = (BigInt.one << 32) - BigInt.one

class XorshiftStar {
    construct new(state) {
        _state  = state & Mask64
    }

    seed(num) { _state = num & Mask64}

    nextInt {
        var x = _state
        x = (x ^ (x >> 12)) & Mask64
        x = (x ^ (x << 25)) & Mask64
        x = (x ^ (x >> 27)) & Mask64
        _state = x
        return (((x * Const) & Mask64) >> 32) & Mask32
    }

    nextFloat { nextInt.toNum / 2.pow(32) }
}

var randomGen = XorshiftStar.new(BigInt.new(1234567))
for (i in 0..4) System.print(randomGen.nextInt)

var counts = List.filled(5, 0)
randomGen.seed(BigInt.new(987654321))
for (i in 1..1e5) {
    var i = (randomGen.nextFloat * 5).floor
    counts[i] = counts[i] + 1
}
System.print("\nThe counts for 100,000 repetitions are:")
for (i in 0..4) System.print("  %(i) : %(counts[i])")
