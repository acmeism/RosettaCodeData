import "/big" for BigInt

var pt = "Rosetta Code"
System.print("Plain text:            : %(pt)")
var n = BigInt.new("9516311845790656153499716760847001433441357")
var e = BigInt.new("65537")
var d = BigInt.new("5617843187844953170308463622230283376298685")
var ptn = BigInt.zero
// convert plain text to a number
for (b in pt.bytes) {
    ptn = (ptn << 8) | BigInt.new(b)
}
if (ptn >= n) {
    System.print("Plain text message too long")
    return
}
System.print("Plain text as a number : %(ptn)")

// encode a single number
var etn = ptn.modPow(e, n)
System.print("Encoded                : %(etn)")

// decode a single number
var dtn = etn.modPow(d, n)
System.print("Decoded                : %(dtn)")

// convert number to text
var db = List.filled(16, 0)
var dx = 16
var bff = BigInt.new(255)
while (dtn.bitLength > 0) {
    dx = dx - 1
    db[dx] = (dtn & bff).toSmall
    dtn = dtn >> 8
}
var s = ""
for (i in dx..15) s = s + String.fromByte(db[i])
System.print("Decoded number as text : %(s)")
