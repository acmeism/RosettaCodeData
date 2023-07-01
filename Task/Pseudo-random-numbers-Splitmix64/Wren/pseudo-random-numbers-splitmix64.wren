import "/big" for BigInt

var Const1 = BigInt.fromBaseString("9e3779b97f4a7c15", 16)
var Const2 = BigInt.fromBaseString("bf58476d1ce4e5b9", 16)
var Const3 = BigInt.fromBaseString("94d049bb133111eb", 16)
var Mask64 = (BigInt.one << 64) - BigInt.one

class Splitmix64 {
    construct new(state) {
        _state  = state
    }

    nextInt {
        _state = (_state + Const1) & Mask64
        var z = _state
        z = ((z ^ (z >> 30)) * Const2) & Mask64
        z = ((z ^ (z >> 27)) * Const3) & Mask64
        return (z ^ (z >> 31)) & Mask64
    }

    nextFloat { nextInt.toNum / 2.pow(64) }
}

var randomGen = Splitmix64.new(BigInt.new(1234567))
for (i in 0..4) System.print(randomGen.nextInt)

var counts = List.filled(5, 0)
randomGen = Splitmix64.new(BigInt.new(987654321))
for (i in 1..1e5) {
    var i = (randomGen.nextFloat * 5).floor
    counts[i] = counts[i] + 1
}
System.print("\nThe counts for 100,000 repetitions are:")
for (i in 0..4) System.print("  %(i) : %(counts[i])")
