package main

import "core:fmt"
import "core:math"

TWO64 :f64: 1 << 64

SplitMix64 :: struct {
    state: u64,
}

next_int :: proc(rng: ^SplitMix64) -> u64 {
    rng.state += 0x9e3779b97f4a7c15
    z := rng.state
    z = (z ~ (z >> 30)) * 0xbf58476d1ce4e5b9
    z = (z ~ (z >> 27)) * 0x94d049bb133111eb
    return z ~ (z >> 31)
}

next_float :: proc(rng: ^SplitMix64) -> f64 {
    return f64(next_int(rng)) / TWO64
}

main :: proc() {
    rng := SplitMix64{1234567}

    for i in 0..<5 {
        fmt.println(next_int(&rng))
    }

    rng.state = 987654321

    vec5 := [5]int{0,0,0,0,0}
    for i in 0..<100000 {
        j := int(math.floor(next_float(&rng) * 5.))
        vec5[j] += 1
    }

    for v,i in vec5 {
        fmt.printf("%d: %d   ", i, v)
    }
}
