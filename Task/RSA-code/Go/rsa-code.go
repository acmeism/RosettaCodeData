package main

import (
    "fmt"
    "math/big"
)

func main() {
    var n, e, d, bb, ptn, etn, dtn big.Int
    pt := "Rosetta Code"
    fmt.Println("Plain text:            ", pt)

    // a key set big enough to hold 16 bytes of plain text in
    // a single block (to simplify the example) and also big enough
    // to demonstrate efficiency of modular exponentiation.
    n.SetString("9516311845790656153499716760847001433441357", 10)
    e.SetString("65537", 10)
    d.SetString("5617843187844953170308463622230283376298685", 10)

    // convert plain text to a number
    for _, b := range []byte(pt) {
        ptn.Or(ptn.Lsh(&ptn, 8), bb.SetInt64(int64(b)))
    }
    if ptn.Cmp(&n) >= 0 {
        fmt.Println("Plain text message too long")
        return
    }
    fmt.Println("Plain text as a number:", &ptn)

    // encode a single number
    etn.Exp(&ptn, &e, &n)
    fmt.Println("Encoded:               ", &etn)

    // decode a single number
    dtn.Exp(&etn, &d, &n)
    fmt.Println("Decoded:               ", &dtn)

    // convert number to text
    var db [16]byte
    dx := 16
    bff := big.NewInt(0xff)
    for dtn.BitLen() > 0 {
        dx--
        db[dx] = byte(bb.And(&dtn, bff).Int64())
        dtn.Rsh(&dtn, 8)
    }
    fmt.Println("Decoded number as text:", string(db[dx:]))
}
