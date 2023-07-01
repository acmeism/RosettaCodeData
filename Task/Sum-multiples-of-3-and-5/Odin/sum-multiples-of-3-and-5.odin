package main

import "core:fmt"

sumdiv :: proc(n, d: i128) -> i128 {
    m := n / d
    return (m % 2 == 0)? \
            m/2 * (m + 1) * d : \
            (m + 1)/2 * m * d
}

sum3or5 :: proc(n: i128) -> i128 {
    return sumdiv(n, 3) + sumdiv(n, 5) - sumdiv(n, 15)
}

main :: proc() {
    sum := 0
    for n in 1..=999 {
        if n % 3 == 0 || n % 5 == 0 {
            sum += n
        }
    }
    fmt.println("The sum of all multiples of 3 and 5 < 1000 is", sum)
    fmt.println("The sum of all multiples of 3 and 5 < 1e19 is", sum3or5(1e19 - 1))
}
