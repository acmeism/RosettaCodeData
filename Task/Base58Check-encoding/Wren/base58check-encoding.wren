import "./big" for BigInt
import "./fmt" for Fmt

var alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
var big58 = BigInt.new(58)

var convertToBase58 = Fn.new { |hash, base|
    var x = (base == 16 && hash.startsWith("0x")) ? BigInt.fromBaseString(hash[2..-1], 16) :
                                                    BigInt.fromBaseString(hash, base)
    var sb = ""
    while (x > BigInt.zero) {
        var r = (x % big58).toSmall
        sb = sb + alphabet[r]
        x = x / big58
    }
    return sb[-1..0]
}

var s = "25420294593250030202636073700053352635053786165627414518"
var b = convertToBase58.call(s, 10)
System.print("%(s) -> %(b)")
var hashes = [
    "0x61",
    "0x626262",
    "0x636363",
    "0x73696d706c792061206c6f6e6720737472696e67",
    "0x516b6fcd0f",
    "0xbf4f89001e670274dd",
    "0x572e4794",
    "0xecac89cad93923c02321",
    "0x10c8511e"
]
for (hash in hashes) {
    var b58 = convertToBase58.call(hash, 16)
    Fmt.print("$-56s -> $s", hash, b58)
}
