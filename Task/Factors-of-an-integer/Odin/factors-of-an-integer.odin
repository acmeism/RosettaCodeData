package main

import "core:fmt"
import "core:slice"

factors :: proc(n: int) -> [dynamic]int {
    d := 1
    factors := make([dynamic]int)

    for {
        q := n / d
        r := n % d

        if d >= q {
            if d == q && r == 0 {
                append(&factors, d)
            }
            slice.sort(factors[:])
            return factors
        }
        if r == 0 {
            append(&factors, d, q)
        }

        d += 1
    }
}

main :: proc() {
    for n in ([?]int{100, 108, 999, 255, 256, 257}) {
        a := factors(n)
        fmt.println("The factors of", n, "are", a)
        delete(a)
    }
}
