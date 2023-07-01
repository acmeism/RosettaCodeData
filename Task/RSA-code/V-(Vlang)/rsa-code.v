/*import math.big
fn main() {
    //var bb, ptn, etn, dtn big.Int
    pt := "Rosetta Code"
    println("Plain text:            $pt")

    // a key set big enough to hold 16 bytes of plain text in
    // a single block (to simplify the example) and also big enough
    // to demonstrate efficiency of modular exponentiation.
    n := big.integer_from_string("9516311845790656153499716760847001433441357")?
    e := big.integer_from_string("65537")?
    d := big.integer_from_string("5617843187844953170308463622230283376298685")?

    mut ptn := big.zero_int
    // convert plain text to a number
    for b in pt.bytes() {
        bb := big.integer_from_i64(i64(b))
        ptn = ptn.lshift(8).bitwise_or(bb)
    }
    if ptn >= n {
        println("Plain text message too long")
        return
    }
    println("Plain text as a number:$ptn")

    // encode a single number
    etn := ptn.big_mod_pow(e,n)
    println("Encoded:               $etn")

    // decode a single number
    mut dtn := etn.big_mod_pow(d,n)
    println("Decoded:               $dtn")

    // convert number to text
    mut db := [16]u8{}
    mut dx := 16
    bff := big.integer_from_int(0xff)
    for dtn.bit_len() > 0 {
        dx--
        bb := dtn.bitwise_and(bff)
        db[dx] = u8(i64(bb.int()))
        dtn = dtn.rshift(8)
        println('${db[0..].bytestr()} ${dtn.bit_len()}')
    }
    println("Decoded number as text: ${db[dx..].bytestr()}")
}*/

import math.big
fn main() {
    //var bb, ptn, etn, dtn big.Int
    pt := "Hello World"
    println("Plain text:            $pt")

    // a key set big enough to hold 16 bytes of plain text in
    // a single block (to simplify the example) and also big enough
    // to demonstrate efficiency of modular exponentiation.
    n := big.integer_from_string("9516311845790656153499716760847001433441357")?
    e := big.integer_from_string("65537")?
    d := big.integer_from_string("5617843187844953170308463622230283376298685")?

    mut ptn := big.zero_int
    // convert plain text to a number
    for b in pt.bytes() {
        bb := big.integer_from_i64(i64(b))
        ptn = ptn.lshift(8).bitwise_or(bb)
    }
    if ptn >= n {
        println("Plain text message too long")
        return
    }
    println("Plain text as a number:$ptn")

    // encode a single number
    etn := ptn.big_mod_pow(e,n)
    println("Encoded:               $etn")

    // decode a single number
    mut dtn := etn.big_mod_pow(d,n)
    println("Decoded:               $dtn")

    // convert number to text
    mut db := [16]u8{}
    mut dx := 16
    bff := big.integer_from_int(0xff)
    for dtn.bit_len() > 0 {
        dx--
        bb := dtn.bitwise_and(bff)
        db[dx] = u8(i64(bb.int()))
        dtn = dtn.rshift(8)
    }
    println("Decoded number as text: ${db[dx..].bytestr()}")
}
