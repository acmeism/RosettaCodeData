import "./fmt" for Fmt
import "./big" for BigInt

var max = 2.pow(53) // 9007199254740992 (16 digits)
for (i in 1...max) Fmt.print("$d", i)

var bi = BigInt.new(max.toString)
while (true) {
    Fmt.print("$i", bi)
    bi = bi + 1
}
