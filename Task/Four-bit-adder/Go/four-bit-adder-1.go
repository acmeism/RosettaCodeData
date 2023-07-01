package main

import "fmt"

func xor(a, b byte) byte {
    return a&(^b) | b&(^a)
}

func ha(a, b byte) (s, c byte) {
    return xor(a, b), a & b
}

func fa(a, b, c0 byte) (s, c1 byte) {
    sa, ca := ha(a, c0)
    s, cb := ha(sa, b)
    c1 = ca | cb
    return
}

func add4(a3, a2, a1, a0, b3, b2, b1, b0 byte) (v, s3, s2, s1, s0 byte) {
    s0, c0 := fa(a0, b0, 0)
    s1, c1 := fa(a1, b1, c0)
    s2, c2 := fa(a2, b2, c1)
    s3, v = fa(a3, b3, c2)
    return
}

func main() {
    // add 10+9  result should be 1 0 0 1 1
    fmt.Println(add4(1, 0, 1, 0, 1, 0, 0, 1))
}
