package main

import "core:fmt"
import "core:os"
import "core:strconv"

Arg :: struct {
    fn : proc (^Arg) -> int,
    k : ^int,
    x1, x2, x3, x4, x5 : ^Arg,
}

B :: proc (a : ^Arg) -> int {
    a.k^ -= 1
    k := a.k^
    return A(&Arg { fn = B, k = &k, x1 = a, x2 = a.x1, x3 = a.x2, x4 = a.x3, x5 = a.x4 } )
}

A :: proc (a : ^Arg) -> int {
    return a.x4->fn() + a.x5->fn() if a.k^ <= 0 else B(a)
}

main :: proc () {
    f_1 :: proc (^Arg) -> int { return -1 }
    f0  :: proc (^Arg) -> int { return 0 }
    f1  :: proc (^Arg) -> int { return 1 }

    k := strconv.atoi(os.args[1]) if len(os.args) == 2 else 10
    fmt.println(A(&Arg { fn = B, k = &k, x1 = &Arg { fn = f1 }, x2 = &Arg { fn = f_1 }, x3 = &Arg { fn = f_1 }, x4 = &Arg { fn = f1 }, x5 = &Arg { fn = f0 } }))
}
