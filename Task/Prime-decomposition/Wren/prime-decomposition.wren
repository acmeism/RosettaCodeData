import "./big" for BigInt
import "./fmt" for Fmt

var vals = [1 << 31, 1234567, 333333, 987653, 2 * 3 * 5 * 7 * 11 * 13 * 17]
for (val in vals) {
    Fmt.print("$10d -> $n", val, BigInt.primeFactors(val))
}
