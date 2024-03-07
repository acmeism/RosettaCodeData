import "./big" for BigInt

var Const  = BigInt.new("6364136223846793005")
var Mask64 = (BigInt.one << 64) - BigInt.one
var Mask32 = (BigInt.one << 32) - BigInt.one

class Pcg32 {
    construct new() {
        _state  = BigInt.fromBaseString("853c49e6748fea9b", 16)
        _inc    = BigInt.fromBaseString("da3e39cb94b95bdb", 16)
    }

    seed(seedState, seedSequence) {
        _state = BigInt.zero
        _inc = ((seedSequence << BigInt.one) | BigInt.one) & Mask64
        nextInt
        _state = _state + seedState
        nextInt
    }

    nextInt {
        var old = _state
        _state = (old*Const + _inc) & Mask64
        var xorshifted = (((old >> 18) ^ old) >> 27) & Mask32
        var rot = (old >> 59) & Mask32
        return ((xorshifted >> rot) | (xorshifted << ((-rot) & 31))) & Mask32
    }

    nextFloat { nextInt.toNum / 2.pow(32) }
}

var randomGen = Pcg32.new()
randomGen.seed(BigInt.new(42), BigInt.new(54))
for (i in 0..4) System.print(randomGen.nextInt)

var counts = List.filled(5, 0)
randomGen.seed(BigInt.new(987654321), BigInt.one)
for (i in 1..1e5) {
    var i = (randomGen.nextFloat * 5).floor
    counts[i] = counts[i] + 1
}
System.print("\nThe counts for 100,000 repetitions are:")
for (i in 0..4) System.print("  %(i) : %(counts[i])")
