package main

import "core:fmt"

main :: proc() {
    for i := 1024 ; i > 0 ; i /= 2 {
		fmt.println(i)
    }
}
