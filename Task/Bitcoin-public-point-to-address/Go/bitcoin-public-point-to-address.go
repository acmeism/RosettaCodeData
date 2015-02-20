package main

import (
    "crypto/sha256"
    "encoding/hex"
    "errors"
    "fmt"

    "golang.org/x/crypto/ripemd160"
)

// Point is a type for a bitcoin public point.
type Point struct {
    x, y [32]byte
}

// SetHex takes two hexidecimal strings and decodes them into the receiver.
func (p *Point) SetHex(x, y string) error {
    if len(x) != 64 || len(y) != 64 {
        return errors.New("invalid hex string length")
    }
    if _, err := hex.Decode(p.x[:], []byte(x)); err != nil {
        return err
    }
    _, err := hex.Decode(p.y[:], []byte(y))
    return err
}

// A25 type in common with Bitcoin/address validation task.
type A25 [25]byte

// doubleSHA256 method in common with Bitcoin/address validation task.
func (a *A25) doubleSHA256() []byte {
    h := sha256.New()
    h.Write(a[:21])
    d := h.Sum([]byte{})
    h = sha256.New()
    h.Write(d)
    return h.Sum(d[:0])
}

// UpdateChecksum computes the address checksum on the first 21 bytes and
// stores the result in the last 4 bytes.
func (a *A25) UpdateChecksum() {
    copy(a[21:], a.doubleSHA256())
}

// SetPoint takes a public point and generates the corresponding address
// into the receiver, complete with valid checksum.
func (a *A25) SetPoint(p *Point) {
    c := [65]byte{4}
    copy(c[1:], p.x[:])
    copy(c[33:], p.y[:])
    h := sha256.New()
    h.Write(c[:])
    s := h.Sum([]byte{})
    h = ripemd160.New()
    h.Write(s)
    h.Sum(a[1:1])
    a.UpdateChecksum()
}

// Tmpl in common with Bitcoin/address validation task.
var tmpl = []byte("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")

// A58 returns a base58 encoded bitcoin address corresponding to the receiver.
// Code adapted from the C solution to this task.
func (a *A25) A58() []byte {
    var out [34]byte
    for n := 33; n >= 0; n-- {
        c := 0
        for i := 0; i < 25; i++ {
            c = c*256 + int(a[i])
            a[i] = byte(c / 58)
            c %= 58
        }
        out[n] = tmpl[c]
    }
    i := 1
    for i < 34 && out[i] == '1' {
        i++
    }
    return out[i-1:]
}

func main() {
    // parse hex into point object
    var p Point
    err := p.SetHex(
        "50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352",
        "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6")
    if err != nil {
        fmt.Println(err)
        return
    }
    // generate address object from point
    var a A25
    a.SetPoint(&p)
    // show base58 representation
    fmt.Println(string(a.A58()))
}
