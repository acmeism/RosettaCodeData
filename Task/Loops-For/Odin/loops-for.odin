package main

import "core:fmt"

main :: proc() {
    for i := 1 ; i <= 5 ; i += 1 {
        for j := 1; j <= i; j += 1 {
    		fmt.printf("*")
        }
        fmt.println()
    }
}
