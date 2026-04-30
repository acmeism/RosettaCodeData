package main

import "core:fmt"

main :: proc() {
	// No difference between chracters and ints
    a:int=97
    fmt.println(rune(a))
    number:int='a'
    fmt.println(number)
}
